git = settings().matlab.sourcecontrol.git;
git.PrivateKeyFile.PersonalValue = "C:\Users\matth\.ssh\id_ed25519";
git.PublicKeyFile.PersonalValue = "C:\Users\matth\.ssh\id_ed25519.pub";
git.KeyHasPassphrase.PersonalValue = true;



%% Capstone Bundle Adjustment
clc, clear, close all;




% Please indicate what lab this is
lab = "Lab 2";

% Accesses paths in file structure in macos
addpath(genpath([pwd,'/Inputs']));
addpath(genpath([pwd,'/Functions']));

% Indicate Folder name for location of DICOM files
foldername="Inputs/Fluoro/";

dicom_data=DICOMread(foldername);
%dicomview=DICOMviewer()

% radius = 1/2 distancesourcetodetector
% phi= RAO/LAO angle
% theta= CRA/ CAU angle
% from these we can compute spherical coordinate location for the EOPs

% Reading in given data
if lab == "Lab 2"
    pho = load('2D_point_Position.pho'); % Image point coordinates
    int = int_maker(dicom_data); % Interior Orientation Parameters (known/approx IOP)
    % Extract wpk from DICOM files
    angles=transpose(angle_extract(dicom_data));
    IDcamXcYcZc=IDCamXYZc(angles,int);
       
    ext = [IDcamXcYcZc,angles]; % Exterior Orientation Parameters (approx/obs EOP) Image-X Y Z  w p k
  
    con = load('ControlPoints.con'); % Control Points (known/obs control points) taken from CT scan
   
    tie=load('tie.tie');
    %tie=[];
else

    disp("Check Lab title at top of code")

end




%% Data correlation
% Sorting all points into 1 matrix, with point and ID
sorted = store_sort(ext, con, pho, int, tie);

% Order of sorted
% 1    2   3   4   5   6   7  8  9  10  11  12  13     14     15  16    17
% Xc   Yc  Zc  w   p   k   X  Y  Z  xp  yp  c   x_obs  y_obs  Pt  img t or c
% ext ext ext ext ext ext ct ct ct int int int  pho    pho              1/2


%% Setup Initial Iteration
n = 2*size(pho, 1); %2*p where p = number of image points
m = size(unique(pho(:, 2), 'rows'), 1); % number of images
ue = 6*m; %6*m where m = number images


[~, rows] = unique(sorted(:, 15));
sorted_points = sorted(rows, :);

uo = 3*size(sorted_points, 1); % 3*q where q = number of objects points


% Standard deviation is 1mm or 1 pixel
stddev = 1;

% estimated variance factor
eVF = 1; 

Po=0;

% Create Ae Matrix Initial
ae = ae_matrix(pho, sorted, n, ue);

% Create Ao Matrix Intial 
%ao = ao_matrix(pho, sorted, n, uo);
%ao = ao_matrix_new(pho, sorted, n, uo);

% Create Ai Matrix Initial
ai = ai_matrix(sorted, n);
ui = size(ai, 2);


% Create w misclosure vector Intial
w = w_vector(sorted);

% Create delta vector Initial
all_deltas = ones(ue + uo, 1);

% Saves our intial sorted values, as sorted will be updated
orig_sorted = sorted; 

% Store initial parameters
ext_initial = ext;
int_initial = int;
con_initial = con;
tie_initial = tie;
pho_inital = pho;

% Iteration counter
iteration = 0;

% Boolean that tells whether we continue to iterate
iterate = true;

%% Begin Iteration 

%while iterate == true
for i = 1:5 % debugging
    
    % Create Ae matrix 
    ae = ae_matrix(pho, sorted, n, ue);

    % Create Ao matrix  
    ao = ao_matrix(pho, sorted, n, uo);
    %ao = ao_matrix_new(pho, sorted, n, uo);

    % Create Ai matrix
    ai = ai_matrix(sorted, n);
    ag=0;
    Pg=0;
    wg=0;
   if lab == "Lab 3"
        % Create Ag matrix
        [ag,dist] = Agmatrix(con,tie);
        I=1; %identity for 1x1 P matrix
        v_dist=1; %variance for distance measurement

        Pg= (1/ v_dist)*I; % 1/ variance of the distance measurment x identity matrix ( Pg is a 1x1 matrix)
    end

    % Create w misclosure vector 
    w = w_vector(sorted);
    
    % Create wo
    wo = wo_vector(orig_sorted, sorted, uo, lab);

    %create wg 
   % wg = wg_vector(dist,con);
   
    % Create P Matrix
    % Computes the weight matrix with condition 0 (n x n matrix)
    P = p_matrix(pho, 0, uo, ue, n, sorted, stddev);
    
    
    if lab == "Lab 1"

        % Computes the weight matrix with condition 1 (uo x uo matrix no constraint)
        Po = p_matrix(pho, 1, uo, ue, n, sorted, 1);

    elseif lab == "Lab 2" 
        
        % Computes the weight matrix with condition 2 (uo x uo matrix
        % minimally constrained
        Po = p_matrix(pho, 1, uo, ue, n, sorted, 1); % UPDATED CONDITION TO 1 AS A TEST FOR CAPSTONE

    end
    
    % Create Cl matrix
    Cl = eVF*P^-1;

    % Create the N Matrix
    [N, u] = normal(ae, ao, ai, ag, P, Po, Pg, w, wo, wg, lab);
   
    % Find deltas
    [all_deltas, delta_EOP, delta_OP, delta_IOP] = delta(N, u, ue, uo, ui, lab);

    % Get residuals
   if lab =="Lab 1"

       v= (ae*delta_EOP)+(ao*delta_OP)+w;

   elseif lab=="Lab 2"
       v=(ae*delta_EOP)+(ai*delta_IOP)+(ao*delta_OP)+w;

   elseif lab =="Lab 3"

        v=(ae*delta_EOP)+(ai*delta_IOP)+(ao*delta_OP)+w;


   end

    % Corrections
    it=1;
     if lab =="Lab 2"
         it=1+it
        [ext, con, ~, int] = corrections(ext, pho, con, tie, int, delta_EOP, delta_OP, delta_IOP, lab);
     else
        [ext, con, tie, int] = corrections(ext, pho, con, tie, int, delta_EOP, delta_OP, delta_IOP, lab);
     end
    % Update the sorted matrix
    sorted = store_sort(ext, con, pho, int, tie); 

    % Estimated Variance Factor

%     if lab == "Lab 1"
%     
%         [eVF] = estimateVarianceFactor(ve, P, vo, Po, n, ue, uo);
% 
%     end
% 
%     if lab == "Lab 2"
% 
%         [eVF] = estimateVarianceFactor(v, P, vo, Po, n, ue, uo);
% 
%     end

    
    
    % Check iteration condition
    if max(all_deltas) > 0.001
     
        iterate = true;

    else
        
        iterate = false; 
        
    end
    
    iteration = iteration + 1
    
    % Fail safe incase we go into infinite loop
    if iteration == 500
        
        disp("Fail-safe, max iterations have been reached. Please adjust to go further");
        break;
        
    end
   
end

%% Correcting Pho
pho = correction_pho(pho, v);
[eVF] = estimateVarianceFactor(v, P, n, ue, uo);

%% Variance Covariance Matrices
% Estimated Parameters (uxu)
CxHat = N^-1;

% Residuals (nxn)
if lab == "Lab 1"
    A = [ae ao];
elseif lab == "Lab 2"
    A = [ai ae ao];
end
CvHat = Cl - A*CxHat*A';

%%  ======================= Part 2: Network Analysis =====================
% ========== Normality of Residuals (aka Goodness of Fit Test) ===========
v_standard = zeros(length(v),1);

for i = 1:length(v)
    
    v_standard(i,1)  = v(i,1)/sqrt(abs(CvHat(i,i))); %standardizing residuals with standard deviations
    
end

%Plotting Histogram of Standardized Residuals 
figure 
hold on
normX = [-3:.5:3];
normY = normpdf(normX,0,1);
scatter(normX,normY*60, 250, 'b.') %scatterplot of normal distrubution
histogram(v_standard, 'FaceColor','cyan') %histrogram of standardized residuals
xlabel('Standardized Residuals [mm for Object Points; pixels for ]');
ylabel('Frequency [unitless]');
title('Histogram of Standardized Residuals of Object and Image Points'); 
legend('Population Frequency', 'Sample Frequency', 'location', 'best')
hold off

%% ======================== Error Ellipse ==============================

% Obtain list of images as a vector
U_I = pho(:, 2);
U_I = unique(U_I, 'rows');


ppp=pointcounter(pho); %returns points per image

    for j=1:length(ppp)
        
        figure
        
        for i=1:ppp(j)
            
            CvHat_pic=CvHat(i:ppp(j)*2,i:ppp(j)*2);
            pho_pic=pho(i:ppp(j),3:4);

            plot(pho(i,3),pho(i,4),'r.','MarkerSize',5);
            title(strcat('Plot of Error Ellipse at Each Point in Image', ': ', num2str( U_I(j)))); 
            xlabel('Image Pixels');
            ylabel('Image Pixels');
            hold on %plots point list
            Err_Ellipse=err_ellipse(CvHat_pic,pho_pic);
            
        end
       % ppp(j)
       
    end
 % calculates and plots error ellipse on same plot as points


%% ========== Redundancy Numbers to Determine Network Reliability =========
D_O_F=DOF(con,pho,u); %degrees of freedom


R = CvHat*Cl^-1; %correlated redundancy numbers

r = NaN(length(Cl),1); %uncorrelated redundancy numbers (range: 0-1)

for i = 1:length(Cl)
    
    r(i,1) = CvHat(i,i)/Cl(i,i); 
    
end

%% =================== Data Snooping (Outlier Detection) ==================
% Global Test to Determine Presence of Outliers 
%degrees of freedom: df = n - u = 72 = 60 = 12
%significance: alpha = 0.01
chi2_critVal = 26.22;
%[T, isthereablunder] = globalTest(v, P, eVF, chi2_critVal);

%local test to determine which residuals are blunders (if any)
[w1, idx] = localTest(v, eVF, CvHat, chi2_critVal);

% ========== Redundancy Numbers to Determine Network Reliability =========
v2 = NaN(length(v),1);
for i = 1:length(v)
    v2(i) = v(i)^2;
end

% =====================RMS================

% [RMSx,RMSy,RMS]=RMS(v2,D_O_F,pho); original
[RMSx,RMSy,STDx,STDy,vx,vy]=RMS(v,pho);



%==================Dimensional Quantities================
dim_quant=[length(delta_EOP), length(delta_OP),length(tie),length(con),length(all_deltas),length(pho),D_O_F];


%% =================== OUTPUT =====================

output(v,R,v_standard,RMSx,RMSy,U_I,ppp,pho,eVF,dim_quant,STDx,STDy,vx,vy,int_initial,ext_initial,orig_sorted,stddev,con,tie);








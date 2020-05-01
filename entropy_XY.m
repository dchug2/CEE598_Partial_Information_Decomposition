%% Function to calculate the joint entropy from X and Y
% % XY_pdf is the joint PDF of X and Y (N x N)
function H_2d = entropy_XY(XY_pdf)
    idx = XY_pdf > 0;
    H_2d = sum((-1)*(XY_pdf(idx).*log2(XY_pdf(idx))));
end
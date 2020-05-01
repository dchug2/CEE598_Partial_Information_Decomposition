%% Function to calculate the entropy from a given 1-d PDF
%X_pdf is the 1-D PDF of X data vector
function H = entropy_X(x_pdf)
    idx = x_pdf > 0;
    H = sum((-1)*(x_pdf(idx).*log2(x_pdf(idx))));
end
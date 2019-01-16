% --- Important note 1: 
% --- To execute this code, you first need to execute
% --- The_size_of_the_network_is_known/Main script

% -----------------------------------------------------------------------------
% ----------------------- Input Parameters ------------------------------------
Nodes = [80, 160, 320, 640, 1000];

% --- For each network of size N, will compute and simulate access policies ---
for idx = 1:length(Nodes)
    N = Nodes(idx);
    QMDP(N)
    Q_learning(N)
    
    formatSpec = 'Policy for %d nodes has been computed';
    str = sprintf(formatSpec, N)
end
% --------------------------- Plot Results -----------------------------

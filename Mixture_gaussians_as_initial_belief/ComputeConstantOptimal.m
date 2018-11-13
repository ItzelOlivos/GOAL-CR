function [val] = ComputeConstantOptimal(N)
    step = 0.0001;
    prob_set = step:step:1/2;

    D = zeros(1, length(prob_set));
    for i = 1:length(prob_set)
        tao = prob_set(i);    
        for k = 1:N
            D(i) = D(i) + (1/(k*tao*(1-tao)^(k-1)));
        end
    end
    [i,j] = min(D);
    val = prob_set(j);    
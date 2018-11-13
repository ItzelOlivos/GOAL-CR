function [p, EQcurrent] = get_versus(N, num_nodes, prob_set, distribution, versus, Ecurrent_versus, fixed)

    if versus == 1        
        p = fixed;
    elseif versus == 2
        idp = randi([1 N-1],1);
        p = prob_set(idp);      
    else
        p = 1/Ecurrent_versus;
    end
    
    EQcurrent = 0;
    for n = 2:N + 2
        j = num_nodes(n);
        EQcurrent = EQcurrent + j * distribution(n, 1) * p * (1-p)^(j-1);
    end  
end
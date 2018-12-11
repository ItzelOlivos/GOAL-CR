function [p, fun] = get_continuous_greedy(N, distribution)
    
    str = '@(p)-p*(';
    for j = length(distribution):-1:1
        Coeff = j*distribution(j, 1);
        str2 = strcat(num2str(Coeff), '*(1-p)^(', num2str(j), '-1)+');
        str = strcat(str, str2);                      
    end      
    
    j = 0;
    Coeff = j*distribution(1, 1);
    str2 = strcat(num2str(Coeff), '*(1-p)^(', num2str(j), '-1))');
    str = strcat(str, str2);

    fun = str2func(str);
    p1 = 0;
    p2 = 0.5;

    p = fminbnd(fun,p1,p2);  
end
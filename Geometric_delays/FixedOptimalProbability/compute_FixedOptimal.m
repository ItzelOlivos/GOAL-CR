function [tau] = compute_FixedOptimal(N)
    
    str = '@(p)1*(';
    for i = 1:N-1
        str2 = strcat('(', num2str(i), '*p*(1-p)^(', num2str(i), '-1))^(-1) +');
        str = strcat(str, str2);
    end

    i = N;
    str2 = strcat('(', num2str(i), '*p*(1-p)^(', num2str(i), '-1))^(-1))');
    str = strcat(str, str2);

    fun = str2func(str);

    p1 = 0;
    p2 = 1;

    tau = fminbnd(fun,p1,p2);

function [val, obj] = get_distribution(mu, sigma, x)
    if sigma == 0
        val = zeros(1, 2*mu);
        val(mu) = 1;
        obj = 0;
    else    
        pd = makedist('Normal','mu', mu, 'sigma', sigma);
        obj = truncate(pd, x(1),x(end));
        val = pdf(obj, x);    

        figure;
        plot(x,pdf(pd,x),'Color','red','LineWidth',2)
        hold on;
        plot(x,pdf(obj,x),'Color','blue','LineWidth',2,'LineStyle',':')
        legend({'Normal','Truncated'},'Location','NE')
        hold off;
    end

    
% function [d] = get_distribution(m, var)
%     N = m;
%     v = ceil(var*N/100); % por ciento de N
%     r = randi([N-v N+v], 1, N*1000);
%     res = tabulate(r);
%     k = find(res(:, 3));
%     d = cat(2, [0], res(:,3)', zeros(1, k(1)));
%     d(d>0) = 1/length(d(d>0));    

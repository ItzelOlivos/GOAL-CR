function [val, gm] = get_distribution(mu1, mu2, sigma, prop1, prop2, x, flag)
    if sigma == 0
        val = zeros(1, 2*mu1);
        val(mu1) = 1;
        gm = 0;
    else
        mu = [mu1; mu2];
        p = [prop1 prop2];
        gm = gmdistribution(mu, sigma, p);
        
        val = pdf(gm, x');                            

        if flag == true
            figure;
            plot(x, pdf(gm,x'),'Color','red','LineWidth',2)
            hold on;
            plot(x, pdf(gm,x'),'Color','blue','LineWidth',2,'LineStyle',':')
            legend({'Normal','Truncated'},'Location','NE')
            hold off;
        end
    end

    
% function [d] = get_distribution(m, var)
%     N = m;
%     v = ceil(var*N/100); % por ciento de N
%     r = randi([N-v N+v], 1, N*1000);
%     res = tabulate(r);
%     k = find(res(:, 3));
%     d = cat(2, [0], res(:,3)', zeros(1, k(1)));
%     d(d>0) = 1/length(d(d>0));    

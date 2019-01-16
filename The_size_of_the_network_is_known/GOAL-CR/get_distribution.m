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

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
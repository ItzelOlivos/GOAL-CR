function [val] = get_distribution(mu, sigma, x)
    if sigma == 0
        val = zeros(1, 2*mu);
        val(mu) = 1;        
    else
        val = binopdf(x, mu, sigma);
        figure;
        plot(x,val,'Color','red','LineWidth',2)        
    end  

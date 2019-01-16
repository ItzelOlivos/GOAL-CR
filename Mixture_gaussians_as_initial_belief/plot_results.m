function plot_results(span, distance_between_means, sigma, proportion_gaussian_1, proportion_gaussian_2)

    mu1 = ceil(span/2) - distance_between_means/2;
    mu2 = ceil(span/2) + distance_between_means/2;

    MOptimal = zeros(1, length(mu1));
    RatioOptimal = zeros(1, length(mu1));
    for i = 1:length(mu1)
        m1 = mu1(i);
        m2 = mu2(i);
        str = sprintf('PerfectInformation/Results_%d_%d_%d_%d_%d_%d', span, m1, m2, sigma, proportion_gaussian_1, proportion_gaussian_2);
        load(str);        
        MOptimal(i) = StatisticsDCF(1);                     
        RatioOptimal(i) = MOptimal(i)-MOptimal(1);
    end        

    MGreedy = zeros(1, length(mu1));
    RatioGreedy = zeros(1, length(mu1));
    for i = 1:length(mu1)
        m1 = mu1(i);
        m2 = mu2(i);
        str = sprintf('GOAL-CR/Results_%d_%d_%d_%d_%d_%d', span, m1, m2, sigma, proportion_gaussian_1, proportion_gaussian_2);
        load(str);        
        MGreedy(i) = StatisticsDCF(1);                     
        RatioGreedy(i) = MGreedy(i)-MOptimal(1);
    end 
    
    MGreedyCon = zeros(1, length(mu1));
    RatioGreedyCon = zeros(1, length(mu1));
    for i = 1:length(mu1)
        m1 = mu1(i);
        m2 = mu2(i);
        str = sprintf('ContinuousGOAL-CR/Results_%d_%d_%d_%d_%d_%d', span, m1, m2, sigma, proportion_gaussian_1, proportion_gaussian_2);
        load(str);        
        MGreedyCon(i) = StatisticsDCF(1);                     
        RatioGreedyCon(i) = MGreedyCon(i)-MOptimal(1);
    end 


    MFixed = zeros(1, length(mu1));
    RatioFixed = zeros(1, length(mu1));
    for i = 1:length(mu1)
        m1 = mu1(i);
        m2 = mu2(i);
        str = sprintf('FixedOptimalProbability/Results_%d_%d_%d_%d_%d_%d', span, m1, m2, sigma, proportion_gaussian_1, proportion_gaussian_2);
        load(str);        
        MFixed(i) = StatisticsDCF(1);                     
        RatioFixed(i) = MFixed(i)-MOptimal(1);
    end        

    MRule = zeros(1, length(mu1));
    RatioRule = zeros(1, length(mu1));
    for i = 1:length(mu1)
        m1 = mu1(i);
        m2 = mu2(i);
        str = sprintf('GrowthRule/Results_%d_%d_%d_%d_%d_%d', span, m1, m2, sigma, proportion_gaussian_1, proportion_gaussian_2);
        load(str);        
        RatioRule(i) = MRule(i)-MOptimal(1);
    end        

    figure(1)
    subplot(1,2,1)
    for s = 1:length(mu1)
        [val, gm] = get_distribution(mu1(s), mu2(s), sigma, proportion_gaussian_1, proportion_gaussian_2, 0:span, false);
        plot(val)
        hold on
%         if mu1(s) == 495
%             [val, gm] = get_distribution(mu1(s), mu2(s), sigma, proportion_gaussian_1, proportion_gaussian_2, 0:span, false);
%             plot(val)
%             hold on
%         elseif mu1(s) == 460
%             [val, gm] = get_distribution(mu1(s), mu2(s), sigma, proportion_gaussian_1, proportion_gaussian_2, 0:span, false);
%             plot(val)
%             hold on
%         elseif mu1(s) == 275
%             [val, gm] = get_distribution(mu1(s), mu2(s), sigma, proportion_gaussian_1, proportion_gaussian_2, 0:span, false);
%             plot(val)
%             hold on
%         elseif mu1(s) == 50
%             [val, gm] = get_distribution(mu1(s), mu2(s), sigma, proportion_gaussian_1, proportion_gaussian_2, 0:span, false);
%             plot(val)
%             hold on
%         end
    end
    xlabel('Size of the network (nodes)')
    title('a')

    subplot(1,2,2)
    set(gca,'XScale','log')
    hold on
    plot(distance_between_means, RatioGreedy, '-*b')
    plot(distance_between_means, RatioGreedyCon, '-*r')
    plot(distance_between_means, RatioRule, '-*g')
    plot(distance_between_means, RatioFixed, '-*m')
    xlabel('Absolute difference between means \mu_1 and \mu_2')
ylabel('Performance difference with respect to the lower bound of the problem $D^*_{CR}(n) (slots)$')
title('b')
legend({'GOAL-CR', 'Continuous GOAL-CR', 'Growth Rule', 'Fixed optimal probability',},'Location','northwest','NumColumns',1)

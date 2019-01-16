function plot_results(Nodes, probs)
    if length(probs) == 3        
        MOptimal = zeros(length(Nodes), length(probs));
        for idx = 1:length(Nodes)    
            N = Nodes(idx);
            for jdx = 1:length(probs)
                g = probs(jdx);                
                str = sprintf('PerfectInformation/Results_%d_%d', N, g*1000);
                load(str);        
                MOptimal(idx, jdx) = StatisticsDCF(1);
            end    
        end

        MGreedy = zeros(length(Nodes), length(probs));
        for idx = 1:length(Nodes)    
            N = Nodes(idx);
            for jdx = 1:length(probs)
                g = probs(jdx);                
                str = sprintf('GOAL-CR/Results_%d_%d', N, g*1000);
                load(str);        
                MGreedy(idx, jdx) = StatisticsDCF(1);
            end    
        end

        RatioGreedy = zeros(length(Nodes), length(probs));
        for idx = 1:length(probs)
            RatioGreedy(:, idx) = MGreedy(:, idx) - MOptimal(:, idx);
        end

        MFixed = zeros(length(Nodes), length(probs));
        for idx = 1:length(Nodes)    
            N = Nodes(idx);
            for jdx = 1:length(probs)
                g = probs(jdx);                
                str = sprintf('FixedOptimalProbability/Results_%d_%d', N, g*1000);
                load(str);        
                MFixed(idx, jdx) = StatisticsDCF(1);
            end    
        end

        RatioFixed = zeros(length(Nodes), length(probs));
        for idx = 1:length(probs)
            RatioFixed(:, idx) = MFixed(:, idx) - MOptimal(:, idx);
        end

        MRule = zeros(length(Nodes), length(probs));
        for idx = 1:length(Nodes)    
            N = Nodes(idx);
            for jdx = 1:length(probs)
                g = probs(jdx);                
                str = sprintf('GrowthRule/Results_%d_%d', N, g*1000);
                load(str);        
                MRule(idx, jdx) = StatisticsDCF(1);
            end    
        end

        RatioRule = zeros(length(Nodes), length(probs));
        for idx = 1:length(probs)
            RatioRule(:, idx) = MRule(:, idx) - MOptimal(:, idx);
        end 
        
        MCont = zeros(length(Nodes), length(probs));
        for idx = 1:length(Nodes)    
            N = Nodes(idx);
            for jdx = 1:length(probs)
                g = probs(jdx);                
                str = sprintf('ContinuousGOAL-CR/Results_%d_%d', N, g*1000);
                load(str);        
                MCont(idx, jdx) = StatisticsDCF(1);
            end    
        end

        RatioCont = zeros(length(Nodes), length(probs));
        for idx = 1:length(probs)
            RatioCont(:, idx) = MCont(:, idx) - MOptimal(:, idx);
        end 
                

        figure
        set(gca,'XScale','log')
        hold on

        idx = 1;    
        str = sprintf('%0.2f', probs(idx));
        LH(1) = plot(nan, nan, '.w');
        L{1} = str;

        LH(2) = plot(Nodes, RatioGreedy(:, idx), '-*b');
        L{2} = '';
        
        LH(3) = plot(Nodes, RatioCont(:, idx), '-*r');
        L{3} = '';

        LH(4) = plot(Nodes, RatioRule(:, idx), '-*g');
        L{4} = '';

        LH(5) = plot(Nodes, RatioFixed(:, idx), '-*m');
        L{5} = '';

        idx = 2;
        str = sprintf('%0.2f', probs(idx));
        LH(6) = plot(nan, nan, '.w');
        L{6} = str;


        LH(7) = plot(Nodes, RatioGreedy(:, idx), '-^b');
        L{7} = '';
        
        LH(8) = plot(Nodes, RatioCont(:, idx), '-^r');
        L{8} = '';

        LH(9) = plot(Nodes, RatioRule(:, idx), '-^g');
        L{9} = '';

        LH(10) = plot(Nodes, RatioFixed(:, idx), '-^m');
        L{10} = '';

        idx = 3;
        str = sprintf('%0.2f', probs(idx));
        LH(11) = plot(nan, nan, '.w');
        L{11} = str;

        LH(12) = plot(Nodes, RatioGreedy(:, idx), '-+b');
        L{12} = 'GOAL-CR';
        
        LH(13) = plot(Nodes, RatioCont(:, idx), '-+r');
        L{13} = 'continuous GOAL-CR';

        LH(14) = plot(Nodes, RatioRule(:, idx), '-+g');
        L{14} = 'Growth rule';

        LH(15) = plot(Nodes, RatioFixed(:, idx), '-+m');
        L{15} = 'Fixed optimal probability';

        legend(LH, L, 'Location','northwest','NumColumns', 3);
        hold off

        xlabel('Size of the network (nodes)')
        ylabel('Sample avg. contention resolution time (slots)')        
    else
        disp('I need exactly 3 probabilities')
    end

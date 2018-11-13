function plot_results(Nodes, probs)
    if length(probs) == 3        
        MOptimal = zeros(length(Nodes), length(probs));
        for idx = 1:length(Nodes)    
            N = Nodes(idx);
            for jdx = 1:length(probs)
                g = probs(jdx);                
                str = sprintf('Results/Optimal/Results_%d_%d', N, g*1000);
                load(str);        
                MOptimal(idx, jdx) = StatisticsDCF(1);
            end    
        end

        MGreedy = zeros(length(Nodes), length(probs));
        for idx = 1:length(Nodes)    
            N = Nodes(idx);
            for jdx = 1:length(probs)
                g = probs(jdx);                
                str = sprintf('Results/Greedy/Results_%d_%d', N, g*1000);
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
                str = sprintf('Results/Fixed/Results_%d_%d', N, g*1000);
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
                str = sprintf('Results/Rule/Results_%d_%d', N, g*1000);
                load(str);        
                MRule(idx, jdx) = StatisticsDCF(1);
            end    
        end

        RatioRule = zeros(length(Nodes), length(probs));
        for idx = 1:length(probs)
            RatioRule(:, idx) = MRule(:, idx) - MOptimal(:, idx);
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

        LH(3) = plot(Nodes, RatioRule(:, idx), '-*g');
        L{3} = '';

        LH(4) = plot(Nodes, RatioFixed(:, idx), '-*m');
        L{4} = '';

        idx = 2;
        str = sprintf('%0.2f', probs(idx));
        LH(5) = plot(nan, nan, '.w');
        L{5} = str;


        LH(6) = plot(Nodes, RatioGreedy(:, idx), '-^b');
        L{6} = '';

        LH(7) = plot(Nodes, RatioRule(:, idx), '-^g');
        L{7} = '';

        LH(8) = plot(Nodes, RatioFixed(:, idx), '-^m');
        L{8} = '';

        idx = 3;
        str = sprintf('%0.2f', probs(idx));
        LH(9) = plot(nan, nan, '.w');
        L{9} = str;

        LH(10) = plot(Nodes, RatioGreedy(:, idx), '-+b');
        L{10} = 'GOAL-CR';

        LH(11) = plot(Nodes, RatioRule(:, idx), '-+g');
        L{11} = 'Growth Rule';

        LH(12) = plot(Nodes, RatioFixed(:, idx), '-+m');
        L{12} = 'Fixed optimal probability';

        legend(LH, L, 'Location','northwest','NumColumns', 3);
        hold off

        xlabel('Size of the network (nodes)')
        ylabel('Sample avg. contention resolution time (slots)')        
    else
        disp('I need exactly 3 probabilities')
    end

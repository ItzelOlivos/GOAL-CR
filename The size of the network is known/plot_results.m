function [] = plot_results(Nodes, probs)

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

    ErrMOptimal = zeros(length(Nodes), length(probs));
    for idx = 1:length(Nodes)    
        N = Nodes(idx);
        for jdx = 1:length(probs)
            g = probs(jdx);                
            str = sprintf('Results/Optimal/Results_%d_%d', N, g*1000);
            load(str);        
            ErrMOptimal(idx, jdx) = StatisticsDCF(2);
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

    ErrMGreedy = zeros(length(Nodes), length(probs));
    for idx = 1:length(Nodes)    
        N = Nodes(idx);
        for jdx = 1:length(probs)
            g = probs(jdx);                
            str = sprintf('Results/Greedy/Results_%d_%d', N, g*1000);
            load(str);        
            ErrMGreedy(idx, jdx) = StatisticsDCF(2);
        end    
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

    ErrMFixed = zeros(length(Nodes), length(probs));
    for idx = 1:length(Nodes)    
        N = Nodes(idx);
        for jdx = 1:length(probs)
            g = probs(jdx);                
            str = sprintf('Results/Fixed/Results_%d_%d', N, g*1000);
            load(str);        
            ErrMFixed(idx, jdx) = StatisticsDCF(2);
        end    
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

    ErrMRule = zeros(length(Nodes), length(probs));
    for idx = 1:length(Nodes)    
        N = Nodes(idx);
        for jdx = 1:length(probs)
            g = probs(jdx);                
            str = sprintf('Results/Rule/Results_%d_%d', N, g*1000);
            load(str);        
            ErrMRule(idx, jdx) = StatisticsDCF(2);
        end    
    end

    figure
    set(gca,'XScale','log')
    hold on
    idx = 1;
    errorbar(Nodes, MGreedy(:, idx), ErrMGreedy(:, idx), '-sb')
    errorbar(Nodes, MRule(:, idx), ErrMRule(:, idx), '-sg')
    errorbar(Nodes, MFixed(:, idx), ErrMFixed(:, idx), '-sm')
    errorbar(Nodes, MOptimal(:, idx), ErrMOptimal(:, idx), '-sr')
    xlabel('Size of the network (nodes)')
    ylabel('Sample avg. contention resolution time (slots)')
    legend({'GOAL-CR', 'Growth Rule', 'Fixed optimal probability', 'Perfect information', },'Location','northwest','NumColumns',1)
    xlim([0 4000])

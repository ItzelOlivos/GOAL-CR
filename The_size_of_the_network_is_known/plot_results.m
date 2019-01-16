function plot_results(Nodes)

    MOptimal = zeros(1, length(Nodes));
    for idx = 1:length(Nodes)
        N = Nodes(idx);
        str = sprintf('PerfectInformation/Results_%d', N);
        load(str);
        MOptimal(idx) = StatisticsDCF(1);
    end

    ErrMOptimal = zeros(1, length(Nodes));
    for idx = 1:length(Nodes)
        N = Nodes(idx);
        str = sprintf('PerfectInformation/Results_%d', N);
        load(str);
        ErrMOptimal(idx) = StatisticsDCF(2);
    end

    MGreedy = zeros(1, length(Nodes));
    for idx = 1:length(Nodes)
        N = Nodes(idx);
        str = sprintf('GOAL-CR/Results_%d', N);
        load(str);
        MGreedy(idx) = StatisticsDCF(1);
    end

    ErrMGreedy = zeros(1, length(Nodes));
    for idx = 1:length(Nodes)
        N = Nodes(idx);
        str = sprintf('GOAL-CR/Results_%d', N);
        load(str);
        ErrMGreedy(idx) = StatisticsDCF(2);
    end

    MGreedyCon = zeros(1, length(Nodes));
    for idx = 1:length(Nodes)
        N = Nodes(idx);
        str = sprintf('ContinuousGOAL-CR/Results_%d', N);
        load(str);
        MGreedyCon(idx) = StatisticsDCF(1);
    end

    ErrMGreedyCon = zeros(1, length(Nodes));
    for idx = 1:length(Nodes)
        N = Nodes(idx);
        str = sprintf('ContinuousGOAL-CR/Results_%d', N);
        load(str);
        ErrMGreedyCon(idx) = StatisticsDCF(2);
    end

    MFixed = zeros(1, length(Nodes));
    for idx = 1:length(Nodes)
        N = Nodes(idx);
        str = sprintf('FixedOptimalProbability/Results_%d', N);
        load(str);
        MFixed(idx) = StatisticsDCF(1);
    end

    ErrMFixed = zeros(1, length(Nodes));
    for idx = 1:length(Nodes)
        N = Nodes(idx);
        str = sprintf('FixedOptimalProbability/Results_%d', N);
        load(str);
        ErrMFixed(idx) = StatisticsDCF(2);
    end

    MRule = zeros(1, length(Nodes));
    for idx = 1:length(Nodes)
        N = Nodes(idx);
        str = sprintf('GrowthRule/Results_%d', N);
        load(str);
        MRule(idx) = StatisticsDCF(1);
    end

    ErrMRule = zeros(1, length(Nodes));
    for idx = 1:length(Nodes)
        N = Nodes(idx);
        str = sprintf('GrowthRule/Results_%d', N);
        load(str);
        ErrMRule(idx) = StatisticsDCF(2);
    end

    figure
    set(gca,'XScale','log')
    hold on
    errorbar(Nodes, MOptimal, ErrMOptimal, '-sr')
    errorbar(Nodes, MGreedy, ErrMGreedy, '-sb')
    errorbar(Nodes, MGreedyCon, ErrMGreedyCon, '-om')
    errorbar(Nodes, MRule, ErrMRule, '-.^g')
    errorbar(Nodes, MFixed, ErrMFixed, '-sm')

    xlabel('Size of the network (nodes)')
    ylabel('Sample avg. contention resolution time (slots)')
    legend({'Perfect information', 'GOAL-CR', 'Continuous GOAL-CR', 'Growth Rule', 'Fixed optimal probability'})

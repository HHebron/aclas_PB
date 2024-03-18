
clear
clc
close all

%% Figure 2 plot

%toolboxes needed:

%fieldtrip
%https://github.com/fieldtrip/fieldtrip

%circstat
%https://www.mathworks.com/matlabcentral/fileexchange/10676-circular-statistics-toolbox-directional-statistics

%linspecer
%https://uk.mathworks.com/matlabcentral/fileexchange/42673-beautiful-and-distinguishable-line-colors-colormap

%%emmeans
%https://uk.mathworks.com/matlabcentral/fileexchange/71970-emmeans

%%

data_dir = [pwd,'\data'];

load([data_dir,'\fig2_data.mat'])
load([data_dir,'\EEG_layout.mat'])

plot_dir = [pwd,'\plots'];

%%

cfg = [];
cfg.method      = 'montecarlo';
cfg.statistic   = 'ft_statfun_depsamplesFmultivariate';
cfg.alpha       = 0.05;
cfg.numrandomization = 5000;

cfg.ivar   = 1;
cfg.uvar = 2;
cfg.parameter = 'parameter';
cfg.channel = layout2.label;
cfg.neighbours = neighbours;
cfg.dim = [127 1];
cfg.correctm = 'cluster';
cfg.clusterthreshold = 'nonparametric_common';

F = fig2_data.f;
sbjcts = fig2_data.num_participants;

clusters = [2 34 97 126; 12 48 109 114];

colors = linspecer(4);
%Sub-plotswindow
%A 10 Hz ANOVA topo
%B cluster TF ANOVA
%C cluster TF compare opposite phases
%D power spectra
%E frequency ANOVA topo
%F frequency violins
close all

II = 1;

figure('Renderer','painters','Units','Normalize','Position',[0 0 .7 1])
hold on

for exp = 1:2

    cfg.design = [ones(1,length(sbjcts{exp}))  2.*ones(1,length(sbjcts{exp})) 3.*ones(1,length(sbjcts{exp})) 4.*ones(1,length(sbjcts{exp}))];%off or on
    cfg.design(2,:) = [1:length(sbjcts{exp}) 1:length(sbjcts{exp}) 1:length(sbjcts{exp}) 1:length(sbjcts{exp})];

    f = 10;
    bound = .2;
    axx = subplot('position',[.045 .78-.455*(exp-1) .15 .15]);
    hold on


    Y = reshape(fig2_data.average_power_change.exp{exp},127,[]);

    stat = ft_statistics_montecarlo(cfg,Y,cfg.design);

    y = stat.stat;

    minval = 0;
    maxval = max(y);
    scale = max(abs(minval), abs(maxval));
    scale = .5;
    minval = floor(minval/scale)*scale;
    maxval = ceil(maxval/scale)*scale;
    isol = minval:(maxval-minval)/5:maxval;

    ft_plot_topo(layout2.pos(:,1),layout2.pos(:,2),y,'mask',layout2.mask,'outline',layout2.outline, ...
        'interplim','mask','clim',[0 35],'gridscale',300,'isolines',isol);

    ft_hastoolbox('brewermap', 1);
    colormap(axx,flipud(brewermap(64,'*Reds')))
    originalSize1 = get(gca, 'Position');
    colorbar
    set(gca, 'Position', originalSize1);
    set(gca,'FontSize',10)

    scatter(layout2.pos(stat.mask,1),layout2.pos(stat.mask,2),15,'w','filled','MarkerEdgeColor','k');%,'LineWidth',1)

    axis off
    axis square

    set(gca,'TickDir','out')
    set(gca,'Fontsize',12.5)
    set(gca,'TickLength',[0.02, 0.01])

    II = II+1;

    ax2 = subplot('position',[.285 .78-.455*(exp-1) .2 .15]);
    hold on

    x = [];

    for cond = 1:4
        x(:,:,:,cond) = fig2_data.cluster_power_change.exp{exp}.cond{cond};
    end

    clear peas teas
    for r = 1:size(x,1)
        for c = 1:size(x,2)

            [p,tbl,stat] = anova1(reshape(x(r,c,:,:),[],4),[],'off');

            teas(r,c) = tbl{2,5};
            peas(r,c) = p;

        end
    end

    sigvals = peas;
    sigvals(peas<=.05)=1;
    sigvals(peas>.05)=0;

    [L,n] = bwlabel(sigvals);
    plotVals = zeros(size(x,1),size(x,2));

    for i = 1:n

        if sum(sum(L==i))>=15

            for r = 1:length(plotVals(:,1))

                plotVals(r,L(r,:)==i) = 1;

            end

        end

    end

    y = nanmean(teas(F<20,:,:),3);

    y2 = y;
    for r = 1:length(y2(:,1))
        y2(r,plotVals(r,:)==0) = 0;
    end

    x = 1:length(y(1,:,:));

    imagesc(1:length(y2(1,:,:)),F(F<20),y,'AlphaData',0.8,[0 8]);
    ft_hastoolbox('brewermap', 1);
    colormap(ax2,flipud(brewermap(64,'RdBu')))
    imagesc(1:length(y(1,:,:)),F(F<20),y2,[0 8]);

    ft_hastoolbox('brewermap', 1);
    colormap(ax2,flipud(brewermap(64,'RdBu')))

    imagesc(1:length(y2(1,:,:)),F(F<20),y,'AlphaData',0.4,[0 8]);
    ft_hastoolbox('brewermap', 1);
    colormap(ax2,flipud(brewermap(64,'RdBu')))

    [B,L] = bwboundaries(plotVals,'noholes');
    hold on

    for k = 1:length(B)

        boundary = B{k};

        plot(x(boundary(:,2)), F(boundary(:,1)), 'k', 'LineWidth', 1)

    end

    axis tight
    yline(7.5,'LineStyle','--')
    yline(12.5,'LineStyle','--')
    ft_hastoolbox('brewermap', 1);
    colormap(ax2,flipud(brewermap(64,'*Reds')))

    xticks([1 5:5:30])
    xticklabels(0:5:30)
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar

    ylim([4 17])
    xlim([1 30])

    axtmp=gca;
    uistack(axtmp,'top');
    set(axtmp ,'Layer', 'Top')
    set(gca,'TickDir','out')
    set(gca,'Fontsize',12.5)
    set(gca,'LineWidth',1.5)
    set(gca,'TickLength',[0.02, 0.01])

    II = II+1;

    for C = [0 1]

        ax3 = subplot('position',[.525+C*.25 .78-.455*(exp-1) .2 .15]);

        hold on

        x = [];y = [];

        x(:,:,:) = fig2_data.cluster_power_change.exp{exp}.cond{1+C};
        y(:,:,:) = fig2_data.cluster_power_change.exp{exp}.cond{3+C};

        for r = 1:size(x,1)
            for c = 1:size(x,2)

                [h p ci stat] = ttest(x(r,c,:),y(r,c,:));
                teas(r,c) = stat.tstat;
                peas(r,c) = p;

            end
        end

        sigvals = peas;
        sigvals(peas<=.05)=1;
        sigvals(peas>.05)=0;

        [L,n] = bwlabel(sigvals);
        plotVals = zeros(size(x,1),size(x,2));

        for i = 1:n

            if sum(sum(L==i))>=30

                for r = 1:length(plotVals(:,1))

                    plotVals(r,L(r,:)==i) = 1;

                end

            end

        end

        y = nanmean(teas(F<20,:,:),3);

        y2 = y;
        for r = 1:length(y2(:,1))
            y2(r,plotVals(r,:)==0) = 0;
        end

        x = 1:length(y(1,:,:));

        imagesc(1:length(y2(1,:,:)),F(F<20),y,'AlphaData',0.8,[-5 5]);
        ft_hastoolbox('brewermap', 1);
        colormap(ax3,flipud(brewermap(64,'RdBu')))
        imagesc(1:length(y(1,:,:)),F(F<20),y2,[-5 5]);

        ft_hastoolbox('brewermap', 1);
        colormap(ax3,flipud(brewermap(64,'RdBu')))

        imagesc(1:length(y2(1,:,:)),F(F<20),y,'AlphaData',0.4,[-5 5]);
        ft_hastoolbox('brewermap', 1);
        colormap(ax3,flipud(brewermap(64,'RdBu')))

        [B,L] = bwboundaries(plotVals,'noholes');
        hold on

        for k = 1:length(B)

            boundary = B{k};
            plot(x(boundary(:,2)), F(boundary(:,1)), 'k', 'LineWidth', 1)

        end

        axis tight
        yline(7.5,'LineStyle','--')
        yline(12.5,'LineStyle','--')
        ft_hastoolbox('brewermap', 1);
        colormap(ax3,flipud(brewermap(64,'RdBu')))

        xticks([1 5:5:30])
        xticklabels(0:5:30)
        xlabel('Time (s)')
        ylabel('Frequency (Hz)')

        ylim([4 17])
        xlim([1 30])

        axtmp=gca;
        uistack(axtmp,'top');
        set(axtmp ,'Layer', 'Top')

        set(gca,'TickDir','out')
        set(gca,'Fontsize',12.5)
        set(gca,'LineWidth',1.5)
        set(gca,'TickLength',[0.02, 0.01])

        colorbar

        II = II+1;


    end

    for cond = 1:4

        ax = subplot('position',[.075 .565-.455*(exp-1) .12 .15]);

        hold on
        
        y =  fig2_data.cluster_spectrum.exp{exp}(:,:,cond)';

        shadedErrorBar(F,nanmean(y),nanstd(y)./sqrt(size(y,1)),'lineProps',{'Color',colors(cond,:),'LineWidth',1},'patchSaturation',.3);

        xlim([6 13])
        ylim([-.1 .1])
        yticks([-.1 -.05 0 .05 .1])
        ylabel({'Power Change'; '(log-normalized to baseline)'})
        xlabel('Frequency (Hz)')

        axtmp=gca;
        uistack(axtmp,'top');
        set(gca,'TickDir','out')
        set(gca,'Fontsize',12.5)
        set(gca,'LineWidth',1.5)

        set(gca,'TickLength',[0.02, 0.01])

        subplot('position',[.285 .565-.455*(exp-1) .12 .15]);
        hold on

        for i = 1:size(y,2)

            [h,p,ci,stats] = ttest(y(:,i));
            allp(i) = p;
            allt(i) = stats.tstat;

        end

        pl_ = plot(F,allt,'Color',colors(cond,:),'LineWidth',2);

        allt(allp>.05) = NaN;
        pl_ = area(F,allt,'FaceColor',colors(cond,:),'LineWidth',3);
        pl_.EdgeColor = 'none';
        pl_.FaceAlpha = .5;

        xlim([6 13])
        ylim([-5 5])

        axtmp=gca;
        uistack(axtmp,'top');
        set(axtmp ,'Layer', 'Top')
        set(gca,'TickDir','out')
        set(gca,'Fontsize',12.5)
        set(gca,'LineWidth',1.5)
        set(gca,'TickLength',[0.02, 0.01])

        yticks([-5 -2.5 0 2.5 5])
        ylabel({'Power Change';'(T-stat)'})
        xlabel('Frequency (Hz)')

    end

    II = II+2;

    ax7 = subplot('position',[.52 .565-.455*(exp-1) .15 .15]);
    hold on

    Y = reshape(fig2_data.frequency_change.exp{exp},127,[]);

    stat = ft_statistics_montecarlo(cfg,Y,cfg.design);

    y = stat.stat;

    minval = 0;
    maxval = max(y);
    scale = max(abs(minval), abs(maxval));
    scale = 10^(floor(log10(scale))-1);
    minval = floor(minval/scale)*scale;
    maxval = ceil(maxval/scale)*scale;
    isol = minval:(maxval-minval)/5:maxval;
    isol = [0 20];
    ft_plot_topo(layout2.pos(:,1),layout2.pos(:,2),y,'mask',layout2.mask,'outline',layout2.outline, ...
        'interplim','mask','clim',[0 35],'gridscale',300,'isolines',isol);

    ft_hastoolbox('brewermap', 1);
    colormap(ax7,flipud(brewermap(64,'*Reds')))

    scatter(layout2.pos(stat.mask,1),layout2.pos(stat.mask,2),15,'w','filled','MarkerEdgeColor','k');

    axis off
    axis square
    originalSize1 = get(gca, 'Position');
    colorbar
    set(gca, 'Position', originalSize1);

    set(gca,'TickDir','out')
    set(gca,'Fontsize',12.5)
    set(gca,'TickLength',[0.02, 0.01])

    II = II+1;
    subplot('position',[.8 .565-.455*(exp-1) .12 .15]);

    hold on
    clear V


    V = squeeze(nanmean(fig2_data.frequency_change.exp{exp}(clusters(exp,:),:,:)));


    yline(0)

    violins = violinplot(V);

    for i = 1:4

        violins(i).ShowMean = 1;
        violins(i).ShowData = 0;
        violins(i).ViolinColor = colors(i,:);

    end

    tbl = table(string(repmat(1:length(sbjcts{exp}),1,4)'),V(:),string(reshape([1:4].*ones(length(sbjcts{exp}),4),[],1)),'VariableNames',{'subs';'freq';'cond'});

    mdl = fitglme(tbl,'freq~cond+(1|subs)');
    stats = anova(mdl);
    emm = emmeans(mdl,{'cond'});


    if stats.pValue(2) >.05

        text(2.5,-.3,['F = ',num2str(round(stats.FStat(2),2,"significant")),', p = ',num2str(round(stats.pValue(2),2,"significant"))],'color',[.5 .5 .5],'horizontalalignment','center')

    elseif stats.pValue(2) <.05 & stats.pValue(2) >.01

        text(2.5,-.3,['F = ',num2str(round(stats.FStat(2),2,"significant")),', p = ',num2str(round(stats.pValue(2),2,"significant"))],'fontweight','bold','horizontalalignment','center')

    elseif stats.pValue(2) <.01 & stats.pValue(2) >.001

        text(2.5,-.3,['F = ',num2str(round(stats.FStat(2),2,"significant")),', p < .01'],'horizontalalignment','center','fontweight','bold')

    else stats.pValue(2) <.001

        text(2.5,-.3,['F = ',num2str(round(stats.FStat(2),2,"significant")),', p < .001'],'horizontalalignment','center','fontweight','bold')

    end

    xlim([.5 4.5])
    ylim([-.4 .6])

    combs = [1 2;1 3;1 4; 2 3;2 4;3 4];

    if stats.pValue(2) <.05

        clear peas

        for comb = 1:size(combs,1)

            L= [strcmp(emm.table.cond,num2str(combs(comb,1)))' - strcmp(emm.table.cond,num2str(combs(comb,2)))']; % double centered

            H = contrasts_wald(mdl,emm,L);
            peas(comb) = H.pVal;

        end

        groups = {[1 2],[1 3],[1 4],[2 3],[2 4],[3 4]};%,[7 8],[8 9]};
        groups = {groups{peas<.05}};
        peas = peas(peas<.05);
        sigstar(groups,peas,0)

        clear peas

        for comb = 1:4
            [h p stat ci] = ttest(V(:,comb));
            peas(comb) = p;
        end

        groups = {[1 1],[2 2],[3 3],[4 4]}
        groups = {groups{peas<.05}};
        peas = peas(peas<.05);
        sigstar(groups,peas,0)

    end

    axtmp=gca;
    uistack(axtmp,'top');
    set(gca,'TickDir','out')
    set(gca,'Fontsize',12.5)
    set(gca,'LineWidth',1.5)
    set(gca,'TickLength',[0.02, 0.01])
    axtmp.XAxis.FontSize = 12;

    ylabel({'Alpha Frequency';' Change (Hz)'})

    xticks(1:4)
    xticklabels({'Pre-Peak';'Post-Peak';'Pre-Trough';'Post-Trough'})

    II = II+1;

end

saveas(gcf,[plot_dir,'\figure_2.svg'])


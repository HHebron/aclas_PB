
clear
% close all
clc

%% Figure 5 

%toolboxes/functions needed:

%linspecer
%https://uk.mathworks.com/matlabcentral/fileexchange/42673-beautiful-and-distinguishable-line-colors-colormap

addpath('C:\Users\hebron\OneDrive - University of Surrey\Documents\MATLAB\Functions\fieldtrip-master\fieldtrip-master')
ft_defaults

%% load data

data_dir = [pwd,'\data'];

load([data_dir,'\fig5_data_1.mat'])
load([data_dir,'\fig5_data_2.mat'])

plot_dir = [pwd,'\plots'];
clear fig5_data_1 fig5_data_2


%% Figure 6

SC = 15;
txt_size = 11;

clc
%close all

Fs = 826;

figure('units','normalized','outerposition',[.1 .1 .65 .75],'Renderer','painters')
hold on

ax = subplot('Position',[.15 .6 .25 .25]);
hold on

f = 2:.1:30;

II = 1;

y = fig5_data_1.power.cond{1};
y2 = fig5_data_2.power.cond{2};

clear teas peas

for i = 1:size(y,1)

    for ii = 1:360

        [h p ci stat] = ttest(squeeze(y(i,ii,:)),squeeze(y2(i,ii,:)));

        teas(i,ii) = stat.tstat;
        peas(i,ii) = p;

    end
end

sigvals = peas;

sigvals(peas<=.05)=1;

sigvals(peas>.05)=0;

[L,n] = bwlabel(sigvals);

plotVals = zeros(size(peas,1),size(peas,2));

for i = 1:n

    if sum(sum(L==i))>=30

        for r = 1:length(plotVals(:,1))

            plotVals(r,L(r,:)==i) = 1;

        end

    end

end

y = teas;
y2 = y;

for r = 1:length(y2(:,1))

    y2(r,plotVals(r,:)==0) = 0;

end

x = 1:size(y,2);

imagesc(1:size(y,2),f,y,'AlphaData',0.8,[-4.5 4.5]);
imagesc(1:size(y,2),f,y2,[-4.5 4.5]);

imagesc(1:size(y,2),f,y,'AlphaData',0.4,[-4.5 4.5]);%[-.000000002 .000000002])

ft_hastoolbox('brewermap', 1);         % ensure this toolbox is on the path
colormap(ax,flipud(brewermap(64,'RdBu')))

[B,L] = bwboundaries(plotVals,'noholes');

for k = 1:length(B)

    boundary = B{k};
    plot(x(boundary(:,2)), f(boundary(:,1)), 'k', 'LineWidth', 1)

end

colorbar
xlim([60 size(teas,2)])
ylim([4 17])

xticks(60:60:360)
xticklabels(0:6)
xlabel('Time (mins)')
ylabel('Frequency (Hz)')

set(gca,'TickDir','out')
ax.XAxis.FontSize = txt_size;
ax.YAxis.FontSize = txt_size;

axtmp=gca;
uistack(axtmp,'top');
set(axtmp ,'Layer', 'Top')
set(gca,'TickDir','out')
set(gca,'Fontsize',12.5)
set(gca,'LineWidth',1.5)
set(gca,'TickLength',[0.02, 0.01])

fig = subplot('Position',[.5 .6 .2 .25]);
hold on

colors = linspecer(4);
colors = [colors([1 3],:); [.5 .5 .5]];

for cond = 1:2

    tmp = fig5_data_2.frequency_line(:,:,cond)';
    SEM = nanstd(tmp,[],2)./sqrt(size(tmp,2));
    shadedErrorBar(1:size(tmp,1),nanmean(tmp,2),SEM,'lineprops', {'color', colors(cond,:),'LineWidth',1.25},'patchSaturation',.3);
    comp(:,:,cond) = tmp;
end

for i = 1:length(SEM)

    [h,p] = ttest(comp(i,:,1),comp(i,:,2));
    allp(i) = p;
end

allp(allp>.05) = NaN;
allp(allp<.05) = .35;
plot(allp,'k','LineWidth',4)


yline(0)
xline(7)
xline(97)
ylabel({'Sham-subtracted';'alpha frequency (Hz)'})

ylim([-.35 .5])
xticks(0:240/10:180)
xticklabels(0:4:30)
xlabel('Time (mins)')
legend({'Pre-Peak';'Pre-Trough'},'Position',[0.625 0.8 0.05 0.025],'FontSize',6)
xlim([0 30*60/10])
set(gca,'TickDir','out')
fig.XAxis.FontSize = txt_size;
fig.YAxis.FontSize = txt_size;
yticks(-.3:.1:.4)
set(gca,'TickDir','out')
fig.XAxis.FontSize = txt_size;
fig.YAxis.FontSize = txt_size;

axtmp=gca;
uistack(axtmp,'top');
set(axtmp ,'Layer', 'Top')
set(gca,'TickDir','out')
set(gca,'Fontsize',12.5)
set(gca,'LineWidth',1.5)
set(gca,'TickLength',[0.02, 0.01])

H = [1 2 0.85];

for T = 1:2   

     fig = subplot('Position',[.625+(H(T)*.1) .6 .075 .25]);
        hold on

V = fig5_data_2.frequency_violins(:,:,T);

    violins = violinplot(V,[],'Width',1);

    for i = 1:2

        violins(i).ViolinColor = colors(i,:);
        violins(i).ShowMean = 1;
        violins(i).ShowData = 0;
        violins(i).ViolinPlot.EdgeColor = [0 0 0];

    end

    A = area([.9 2.1],[max(V(:))+.01*range(V(:)) max(V(:))+.01*range(V(:))],min(V(:))-.01*range(V(:)),'FaceColor','w','EdgeColor','none');
    A.BaseLine.LineStyle = 'none';


    for cond = 1:2

        [h,p] = ttest(V(:,cond));
        groups = {[cond cond]};
        groups = {groups{p<=.1}};
        p = p(p<=.1);
        s = sigstar(groups,p,0);

    end

    clear groups
    groups_ = [1 2];
    groups = {[1 2]};
    clear stats

    for i = 1:length(groups_(:,1))

        [h,p] = ttest(V(:,groups_(i,1)),V(:,groups_(i,2)));       
        stats(i) = p;

    end

    %box on
    axis tight
    yLim = get(gca,'YLim');
    ylim([min(yLim)-.2*range(yLim) max(yLim)+.25*range(yLim)])

    for i = 1:size(V,2)

        scatter(i,V(:,i),SC,colors(i,:),'filled');

    end
   
    SEM = nanstd(V,0,1)./sqrt(size(V,1));
    errorbar(1:size(V,2),nanmean(V,1),SEM,'k','LineWidth',1)

    for sub = 1:size(V,1)

        if V(sub,1)>V(sub,2)
            plot(V(sub,:),'Color',[colors(1,:) .4]);
        else
            plot(V(sub,:),'Color',[colors(2,:) .4],'LineStyle','--');

        end
    end

   
    for i = 1:2
        violins(i).ShowMean = 1;
        violins(i).ViolinColor = colors(i,:);
        violins(i).ShowData = 0;
    end
    
    yline(0)  
    ylim([min(V(:))-.1*range(V(:)) max(V(:))+.45*range(V(:))])
   
    groups = {groups{stats<=.05}};
    stats = stats(stats<=.05);

    sigstar(groups,stats,0)

    ylim([-.35 .5])
    fig.YAxis.Visible = 'off'; % remove y-axis


    xticks([1 2])
    xticklabels({'Pre-Peak';'Pre-Trough'})
    xlim([-.5 3.5])
    set(gca, 'Layer', 'top')
    set(gca,'TickDir','out')
    % H = H+1;
    fig.XAxis.FontSize = txt_size;
    fig.YAxis.FontSize = txt_size;
    xtickangle(45)

    set(gca,'TickDir','out')
    fig.XAxis.FontSize = txt_size;
    fig.YAxis.FontSize = txt_size;

    axtmp=gca;
    uistack(axtmp,'top');
    set(axtmp ,'Layer', 'Top')
    set(gca,'TickDir','out')
    set(gca,'Fontsize',12.5)
    set(gca,'LineWidth',1.5)
    set(gca,'TickLength',[0.02, 0.01])


end


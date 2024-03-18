
clear
clc
close all

%% Figure 1 plot

%toolboxes needed:

%fieldtrip
%https://github.com/fieldtrip/fieldtrip

%circstat
%https://www.mathworks.com/matlabcentral/fileexchange/10676-circular-statistics-toolbox-directional-statistics

%linspecer
%https://uk.mathworks.com/matlabcentral/fileexchange/42673-beautiful-and-distinguishable-line-colors-colormap

 
%% load data

data_dir = [pwd,'\data'];

load([data_dir,'\fig1_data.mat'])

plot_dir = [pwd,'\plots'];

%% plotting

PL_chan = [2 12];

colors = linspecer(4);

close all

figure('Renderer','painters','units','centimeters','Position',[0 0 35 12.5])
hold on

I = 1;
for exp = 1:2

    clear X Y x y YY
%subplot(2,5,I)
ax = subplot('Position',[.04 .6-(exp-1)*.5 .15 .35]);

hold on

for sub = 1:fig1_data.num_participants(exp)

plot(fig1_data.f,fig1_data.power_off.exp{exp}(sub,:),'Color',[.5 .5 .5 .5],'LineWidth',1)

[pks locs] = findpeaks(fig1_data.power_off.exp{exp}(sub,:));
pks(fig1_data.f(locs)<7.5|fig1_data.f(locs)>12.5) = NaN;
locs(fig1_data.f(locs)<7.5|fig1_data.f(locs)>12.5) = NaN;
locs = locs(pks ==max(pks));
pks = pks(pks==max(pks));

if ~isempty((locs))
X(sub) = fig1_data.f(locs);
YY(sub) = pks;
else
X(sub) = NaN;
YY(sub) = NaN;
end

end

scatter(X,YY,10,[.5 .5 .5],'filled','MarkerEdgeColor','k','MarkerFaceAlpha',.5)

plot(fig1_data.f,nanmean(fig1_data.power_off.exp{exp}),'Color',[0 0 0],'LineWidth',1.5)

[pks locs] = findpeaks(nanmean(fig1_data.power_off.exp{exp}));
pks(fig1_data.f(locs)<7.5|fig1_data.f(locs)>12.5) = NaN;
locs(fig1_data.f(locs)<7.5|fig1_data.f(locs)>12.5) = NaN;
locs = locs(pks ==max(pks));
pks = pks(pks==max(pks));

scatter(fig1_data.f(locs), pks,20,[0 0 0],'filled','MarkerEdgeColor','k')
text(fig1_data.f(locs)+.5, pks+1.25,[num2str(fig1_data.f(locs)),' Hz'],'FontWeight','Bold')


area([7.5 12.5], [max(fig1_data.power_off.exp{exp}(:)+.25*range(fig1_data.power_off.exp{exp}(:))) max(fig1_data.power_off.exp{exp}(:)+.25*range(fig1_data.power_off.exp{exp}(:)))],min(fig1_data.power_off.exp{exp}(:))-.25*range(fig1_data.power_off.exp{exp}(:)),'FaceAlpha',.1,'FaceColor','y')
xline(7.5,'LineStyle','--')
xline(12.5,'LineStyle','--')


ylim([min(fig1_data.power_off.exp{exp}(:))-.01*range(fig1_data.power_off.exp{exp}(:)) max(fig1_data.power_off.exp{exp}(:))+.01*range(fig1_data.power_off.exp{exp}(:))])

xlim([4 15])
axis square
set(ax,'FontSize',10)
set(ax,'TickDir','out')
set(ax,'LineWidth',1)
ylabel('Power (z-score)')
xticks(5:2.5:15)
xlabel('Frequency (Hz)')
xtickangle(0)

I = I+1;

ax2 = subplot('Position',[.225 .6-(exp-1)*.5 .15 .35]);

%subplot(2,5,I)
hold on

%lsline
mdl = fitlm(fig1_data.ISI.exp{exp},fig1_data.frequency_off.exp{exp});
PL = plot(mdl);
PL(1).Color = 'none';
legend off
title(' ')
PL(2).LineWidth = 1;
PL(3).LineWidth = 1;
PL(4).LineWidth = 1;

scatter(fig1_data.ISI.exp{exp},fig1_data.frequency_off.exp{exp},20,'w','filled','MarkerEdgeColor','k')

scatter(nanmean(fig1_data.ISI.exp{exp}),nanmean(fig1_data.frequency_off.exp{exp}),30,'r','filled','MarkerEdgeColor','k')


if mdl.Coefficients.pValue(2) >.001
text(9,10.5,{['R^2= ',num2str(round(mdl.Rsquared.ordinary,2,"significant"))];['p = ',num2str(mdl.Coefficients.pValue(2))]})
else
text(9,10.5,{['R^2 = ',num2str(round(mdl.Rsquared.ordinary,2,"significant"))];['p < .001']})

end

ylim([8.75 11])
xlim([8.75 11])
ylabel('')

axis square
set(ax2,'FontSize',10)
set(ax2,'TickDir','out')
set(ax2,'LineWidth',1)

ylabel('Alpha Frequency (Hz)')
xlabel('Inter-Stimulus Interval (Hz)')
xticks(7.5:.5:12.5)
yticks(7.5:.5:12.5)
xtickangle(0)

I = I+1;

%subplot(2,5,I) 
%ax2 = subplot('Position',[.275 .6-(exp-1)*.5 .15 .35]);

ax3 = subplot('Position',[.385 .6-(exp-1)*.5 .15 .35]);

for cond = 1:4
    for sub = 1:fig1_data.num_participants(exp)
polarplot([0 fig1_data.ecHT_angle.exp{exp}(sub,cond)],[0 fig1_data.ecHT_R.exp{exp}(sub,cond)],'Color',colors(cond,:),'LineWidth',1)
hold on
    end

polarscatter([circ_mean(fig1_data.ecHT_angle.exp{exp}(:,cond))],[circ_r(fig1_data.ecHT_angle.exp{exp}(:,cond),fig1_data.ecHT_R.exp{exp}(:,cond))],30,colors(cond,:),'filled','MarkerEdgeColor','k');%,'Color',colors(cond,:),'LineWidth',1)


end

set(gca,'FontSize',10)
set(gca,'LineWidth',1)
set(gca,'TickLength',[0.02, 0.01])

rlim([0 1.1])
rticks([.5 .75 1])

I = I+1;

ax4 = subplot('Position',[.57 .6-(exp-1)*.5 .15 .35]);

for cond = 1:4
    for sub = 1:fig1_data.num_participants(exp)
polarplot([0 fig1_data.fz_angle.exp{exp}(PL_chan(exp),sub,cond)],[0 fig1_data.fz_R.exp{exp}(PL_chan(exp),sub,cond)],'Color',colors(cond,:),'LineWidth',1)
hold on
    end
    polarscatter([circ_mean(fig1_data.fz_angle.exp{exp}(PL_chan(exp),:,cond)')],[circ_r(fig1_data.fz_angle.exp{exp}(PL_chan(exp),:,cond)',fig1_data.fz_R.exp{exp}(PL_chan(exp),:,cond)')],30,colors(cond,:),'filled','MarkerEdgeColor','k');%,'Color',colors(cond,:),'LineWidth',1)
%polarscatter([circ_mean(ecHT_angle(:,cond))],[circ_r(ecHT_angle(:,cond),ecHT_R(:,cond))],30,colors(cond,:),'filled');%,'Color',colors(cond,:),'LineWidth',1)

end
set(gca,'FontSize',10)
set(gca,'LineWidth',1)
set(gca,'TickLength',[0.02, 0.01])

rlim([0 1.1])
rticks([.5 .75 1])

I = I+1;

ax5 = subplot('Position',[.74 .6-(exp-1)*.5 .15 .35]);
hold on

angles = wrapToPi(deg2rad([0 90 180 270]));

for cond = 1:4
for chan = 1:127
[p v] = circ_vtest(fig1_data.fz_angle.exp{exp}(chan,:,cond)', angles(cond));%,fz_R(chan,:)');
veas(chan,cond) = v;
peas(chan,cond) = p;
end
end

%y = nanmean(veas(:,2),2);

y = nanmean(nanmean(fig1_data.fz_R.exp{exp}(:,:,:),2),3);

minval = 0;%min(y);
      maxval = max(y);
      scale = max(abs(minval), abs(maxval));
      scale = .5;%.1;%10^(floor(log10(scale))-1);
      minval = floor(minval/scale)*scale;
      maxval = ceil(maxval/scale)*scale;
      isol = minval:(maxval-minval)/5:maxval;

ft_plot_topo(fig1_data.layout.pos(:,1),fig1_data.layout.pos(:,2),y,'mask',fig1_data.layout.mask,'outline',fig1_data.layout.outline, ...
    'interplim','mask','clim',[0 .75],'gridscale',300,'isolines',isol); 

ft_hastoolbox('brewermap', 1);         % ensure this toolbox is on the path
colormap(ax5,flipud(brewermap(64,'*Reds')))
originalSize1 = get(gca, 'Position');

cb = colorbar;
axis square
axis off

set(gca, 'Position', originalSize1); % Can also use gca instead of h1 if h1 is still active.
set(gca,'FontSize',10)
set(gca,'TickLength',[0.02, 0.01])


%peas = mafdr(peas,'BHFDR','True')  
peas = mafdr(nanmean(peas,2),'BHFDR','True');

scatter(fig1_data.layout.pos(y>=.4&peas<.05,1),fig1_data.layout.pos(y>=.4&peas<.05,2),15,'w','filled','MarkerEdgeColor','k','LineWidth',1)

scatter(fig1_data.layout.pos(PL_chan(exp),1),fig1_data.layout.pos(PL_chan(exp),2),30,colors(1,:)+.2,'LineWidth',2)

%}
end

saveas(gcf,[plot_dir,'\figure_1.svg'])







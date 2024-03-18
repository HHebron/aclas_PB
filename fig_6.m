clear
% close all
clc

%% Figure 6 plot

%toolboxes/functions needed:

%linspecer
%https://uk.mathworks.com/matlabcentral/fileexchange/42673-beautiful-and-distinguishable-line-colors-colormap

%emmeans
%https://uk.mathworks.com/matlabcentral/fileexchange/71970-emmeans

%%

data_dir = [pwd,'\data'];

load([data_dir,'\fig6_data.mat'])

plot_dir = [pwd,'\plots'];


colors = linspecer(4);
colors = [colors([1 3],:); [.5 .5 .5]];


%% plotting

%close all

plot_type = [0 1 1 0 1 1 0 1 1 0 1 0 1 0 1 0 1 0 1 1 0 1 1 0 1 1 0 1 1 ];
clear plot_locs

plot_locs = [.1 .8 .1 .125];
plot_locs = [.1 .8 .1 .15];
plot_locs = [plot_locs;plot_locs+[.125 0 -.055 0]];
plot_locs = [plot_locs;plot_locs(end,:)+[.065 0 0 0]];
plot_locs = [plot_locs;plot_locs+[.3 0 0 0]];
plot_locs = [plot_locs;plot_locs(4:end,:)+[.3 0 0 0]];

plot_locs = [plot_locs;plot_locs(1:2,:)-[.0225 .225 0 0]];
plot_locs = [plot_locs;plot_locs(end-1:end,:)+[.225 0 0 0]];
plot_locs = [plot_locs;plot_locs(end-1:end,:)+[.275 0 0 0]];
plot_locs = [plot_locs;plot_locs(end-1:end,:)+[.225 0 0 0]];

plot_locs = [plot_locs;plot_locs(1:3,:)+[.175 -.45 0 0]];
plot_locs = [plot_locs;plot_locs(end-2:end,:)+[.3 0 0 0]];

plot_locs = [plot_locs;plot_locs(end-5:end,:)+[0 -.225 0 0]];

figure('Renderer','painters','Units','normalized','position',[0 0 .65 1])
hold on

lcount = 1;vcount=1;

for pl = 1:size(plot_locs,1);

    fig =   subplot('position',plot_locs(pl,:));
    hold on

    if plot_type(pl) == 0

        for cond = 1:3
            plot(fig6_data.line_plot_data(cond,:,lcount),'Color',colors(cond,:),'LineWidth',1.2)

        end
        xline(32)

        ylabel(fig6_data.line_plot_names{lcount})
        lcount = lcount+1;

        xticks(0:10:60)
        xticklabels(0:5:30)
        xlabel('Time (mins)')
    else

        V = fig6_data.violin_plot_data(:,:,vcount);
        vcount = vcount+1;
        %stats

        tbl = table(string(repmat(1:length(fig6_data.num_participants),1,3)'),V(:),string(reshape([1:3].*ones(length(fig6_data.num_participants),3),[],1)),'VariableNames',{'subs';'y';'x'});

        mdl = fitglme(tbl,'y~x+(1|subs)');
        stats = anova(mdl);
        emm = emmeans(mdl,{'x'});

        V = V(:,1:2)-V(:,3);
        violins = violinplot(V,[],'Width',1,'Bandwidth',.1*range(V(:)));


        for i = 1:2
            violins(i).ViolinColor = colors(i,:);
            violins(i).ShowMean = 1;
            violins(i).ShowData = 0;
            violins(i).MedianColor = 'none';
            violins(i).MedianPlot.Marker = 'none';
            violins(i).BoxPlot = [];
            violins(i).WhiskerPlot = [];
            violins(i).NotchPlots = [];
            violins(i).MedianPlot = [];
            violins(i).ViolinPlot.EdgeColor = [0 0 0];%[1 1 1];
            violins(i).ViolinPlot.LineWidth = .5;
        end

        A = area([1 2],[max(V(:))+.01*range(V(:)) max(V(:))+.01*range(V(:))],min(V(:))-.01*range(V(:)),'FaceColor','w','EdgeColor','none');
        A.BaseLine.LineStyle = 'none';



        for v = 1:size(V,2)

            scatter(v,V(:,v),10,colors(v,:),'filled');%,'Jitter','on','JitterAmount',.1)

        end

        SEM = nanstd(V,0,1)./sqrt(length(fig6_data.num_participants));
        errorbar(1:size(V,2),nanmean(V,1),SEM,'k','LineWidth',1)
        %  violins = violinplot(V);

        for sub = 1:length(fig6_data.num_participants)

            if V(sub,1)>V(sub,2)
                plot(V(sub,:),'Color',[colors(1,:) .4],'LineWidth',1);
            elseif V(sub,1)<V(sub,2)
                plot(V(sub,:),'Color',[colors(2,:) .4],'LineStyle','-','LineWidth',1);
            else
                plot(V(sub,:),'Color',[.5 .5 .5 .4],'LineStyle','--','LineWidth',1);

            end
        end

        yline(0)
        fig.XAxis.Color = 'none';

        xlim([-1 4])

        combs = [1 2;1 3;2 3];

        if stats.pValue(2) <.05

            clear peas

            for comb = 1:size(combs,1)

                L= [strcmp(emm.table.x,num2str(combs(comb,1)))' - strcmp(emm.table.x,num2str(combs(comb,2)))']; % double centered

                H = contrasts_wald(mdl,emm,L);
                peas(comb) = H.pVal;

            end

            groups = {[1 2],[1 1],[2 2]};
            groups = {groups{peas<=.1}};
            peas = peas(peas<=.1);
            %
            sigstar(groups,peas,0)
        end
        %ylim([min(V(:))-.1*range(V(:)) max(abs(V(:)))+.4*range(V(:))])
        ylim([-max(abs(V(:)))-.05*range(V(:)) max(abs(V(:)))+.3*range(V(:))])


    end
    fig.TickDir = 'out';
    fig.FontSize = 10;

end

saveas(gcf,[plot_dir,'\figure_6.svg'])


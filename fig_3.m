
clear
clc
close all

%% Figure 3 plot

%toolboxes needed:

%circstat
%https://www.mathworks.com/matlabcentral/fileexchange/10676-circular-statistics-toolbox-directional-statistics

%linspecer
%https://uk.mathworks.com/matlabcentral/fileexchange/42673-beautiful-and-distinguishable-line-colors-colormap


%% load data

data_dir = [pwd,'\data'];

load([data_dir,'\fig3_data.mat'])

plot_dir = [pwd,'\plots'];

%%

close all

clear y yy

split = 8;

colors = linspecer(4);

channels = [2 12];

figure('Renderer','painters','units','normalized','outerposition',[0 0 .4 1]);
hold on

firs = [1 1 1];

clear yy

firs = [1 1 1];

JJ = 1;
for filt = 1:3

    for exp = 1:2

        chan = channels(exp);

        fig = subplot(4,2,JJ);
        hold on

        clear group

        C = 1;

        for cond = 1:4

            for sub = 1:length(fig3_data.num_participants{exp})


                if filt == 1
                    tmp2 = fig3_data.ERP.exp{exp}(sub,:,cond);
                elseif filt == 2
                    tmp2 = fig3_data.ecHT_real.exp{exp}(sub,:,cond);
                else
                    tmp2 = double(fig3_data.ecHT_phase.exp{exp}(sub,:,cond));

                end

                clear alpha_pre evoked_post

                if filt ~= 3
                    group(sub,:,cond) = nanmean(tmp2,1);
                else
                    group(sub,:,cond) = circ_mean(tmp2);
                end

            end

            clear y

            if filt ~=3
                y = mean(group(:,:,cond));
            else
                y = circ_mean(group(:,:,cond));
            end

            plot(y,'Color',colors(cond,:))


            xlim([350 700])

            if filt~=3
                h = gca;
                h.XAxis.Color = 'none';
                ylabel('Amplitude')
                firs(filt) = 0;

            else
                yticks(-pi:pi:pi)
                yticklabels({'-pi';'0';'pi'})
                ylabel('Phase (radians)')
                firs(filt) = 0;


            end

            fig.LineWidth = 2;
            xline(500,'LineStyle',':','LineWidth',2)

            if filt == 3

                Y = [];
                R = [];
                for cond = 1:4
                    for sub = 1:length(fig3_data.num_participants{exp})
                        Y = [Y; fig3_data.ecHT_phase.exp{exp}(sub,:,cond)];
                        R = [R; fig3_data.ecHT_r.exp{exp}(sub,:,cond)];
                    end
                end
                clear peas zeds
                for i = 1:1001
                    [p z] = circ_rtest(Y(:,i),R(:,i));

                    peas(i) = p;
                    zeds(i) = z;
                end

                peas(peas>.05) = NaN;
                peas(~isnan(peas)) = 1;
                %scatter(find(peas==1),ones(sum(peas==1),1),30,'k','*')
                plot(peas*4,'k','LineWidth',4)

                imagesc(1:length(zeds),-4.2,zeds,[0 8])
                ft_hastoolbox('brewermap', 1);         % ensure this toolbox is on the path
                colormap(flipud(brewermap(64,'RdBu')))

                ylim([-1.75*pi 1.5*pi])
                yticks(-pi:pi:pi)
                yticklabels({'-pi';'0';'pi'})
                ylabel('Phase (radians)')
                xticks(0:50:1000)
                xticklabels([-1000:100:1000])
                xlabel('Time (ms)')

            end



        end

        JJ = JJ+1;

        if filt~= 3
            for i = 1:1001
                [p,tbl] = anova1(squeeze(group(:,i,:)),[],'off');

                pvals(i) = p;

            end

            plot(find(pvals<.05),1.1*max(max(mean(group,1))).*ones(sum(pvals<.05),1),'k','LineWidth',4)

            ylim([-max(max(abs(mean(group,1))))-.1*max(range(abs(mean(group,1)))) max(max(abs(mean(group,1))))+.3*max(range(abs(mean(group,1))))])
        end





    end
end

JJ = 7;

for exp = 1:2

    %subplot(2,round(num_plots/2),i)
    fig = subplot(4,2,JJ);
    hold on

    x = 1:8;
    y = fig3_data.octile_z(:,exp);
    mdl = fitlm(x,y);
    %pl = plotAdded(mdl,[],'Color','none');
    pl = plot(mdl,'Color','none');

    scatter(x,y,5,'k','filled')
    if p < .001
        text(double(mean(x)),double(max(y)),{['p = ',num2str(round(table2array(mdl.Coefficients(2,4)),2,'significant'))],['r_2 = ',num2str(round(mdl.Rsquared.Ordinary,2,'significant'))]});

    else
        text(double(mean(x)),double(max(y)),{['p<.001'],['R^2 = ',num2str(round(mdl.Rsquared.Ordinary,2,'significant'))]});

    end
    xlabel({'Alpha Power Octile','(low alpha -> high alpha)'})
    ylabel({'Max Z-stat','(non-uniformity)'})
    xlim([0 split+1])
    ylim([min(y)-.25*range(y) max(y)+.2*range(y)])
   
    axis square

    legend off
    fig.LineWidth = 2;

    fitHandle = findobj(pl,'DisplayName','Fit');
    fitHandle.Color = [0 0 0 .5];
    fitHandle.LineWidth = 1.5;

    cbHandles = findobj(pl,'DisplayName','Confidence bounds');
    cbHandles = findobj(pl,'LineStyle',cbHandles.LineStyle, 'Color', cbHandles.Color);

    set(cbHandles, 'Color', [0 0 0 .5], 'LineWidth', 1, 'LineStyle','-')

    xticks(1:split)

    title('')

    JJ = JJ+1;


end

saveas(gcf,[plot_dir,'\figure_3.svg'])


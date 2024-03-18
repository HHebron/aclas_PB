
clear
close all
clc

%% figure 4 plotting script

%toolboxes needed:

%circstat
%https://www.mathworks.com/matlabcentral/fileexchange/10676-circular-statistics-toolbox-directional-statistics

%linspecer
%https://uk.mathworks.com/matlabcentral/fileexchange/42673-beautiful-and-distinguishable-line-colors-colormap


%% load data

data_dir = [pwd,'\data'];

load([data_dir,'\fig4_data.mat'])

plot_dir = [pwd,'\plots'];


%%
clear angs
angs(1,:) = wrapToPi(deg2rad([0:36:360]));
angs(2,:) = wrapToPi(angs-.1*pi);
angs(3,:) = wrapToPi(angs(1,:)+.1*pi);
colorz = linspecer(length(angs(1,:)));
colors = linspecer(4);


for exp = 1:2

    figure('Renderer','painters','units','normalized','outerposition',[0 0 .4 1])
    hold on

    G = 1;
    A = 1;

    angle_start_end(1,:) = circ_mean(squeeze(fig4_data.phase_after.exp{exp}(:,1,:)));
    sem_end(1,:) = circ_std(squeeze(fig4_data.phase_after.exp{exp}(:,1,:)))./sqrt(length(fig4_data.num_participants{exp}));

    for cycs = [10 50 75 100]

        yy = num2str(cycs);
        yy = str2num(yy(end-1:end))/50;

        pred_angle = wrapToPi(angs(1,:)+ 2*yy*pi);

        sem_end(2,:) = circ_std(squeeze(fig4_data.phase_after.exp{exp}(:,cycs,:)))./sqrt(length(fig4_data.num_participants{exp}));

        angle_start_end(2,:) = circ_mean(squeeze(fig4_data.phase_after.exp{exp}(:,cycs,:)));
        angle_start_end(3,:) = (circ_dist(angle_start_end(2,:)',angle_start_end(1,:)'));
        angle_start_end(3,:) = (circ_dist(angle_start_end(2,:)',pred_angle'));

        R_end(1,:) = circ_r(squeeze(fig4_data.phase_after.exp{exp}(:,cycs,:)), squeeze(fig4_data.R_after.exp{exp}(:,cycs,:)));

        fig = subplot(4,3,G);
        hold on
        axis square
        fig.LineWidth = 2;

        if G == 1 | G == 4 | G == 7
            h = gca;
            h.XAxis.Color = 'none';
        end

        errorbar(circ_mean(squeeze(fig4_data.phase_after.exp{exp}(:,1,:))),circ_mean(squeeze(fig4_data.phase_after.exp{exp}(:,cycs,:))),circ_std(squeeze(fig4_data.phase_after.exp{exp}(:,cycs,:)))./sqrt(length(fig4_data.num_participants{exp})),'Color','k','LineStyle','none','LineWidth',1)
        scatter(circ_mean(squeeze(fig4_data.phase_after.exp{exp}(:,1,:))),pred_angle,2.5,'k','filled')

        for ang = 1:length(angs(1,:))

                scatter(circ_mean(squeeze(fig4_data.phase_after.exp{exp}(:,1,ang))),circ_mean(squeeze(fig4_data.phase_after.exp{exp}(:,cycs,ang))),20,colorz(ang,:),'filled','MarkerEdgeColor','k')
                scatter(circ_mean(squeeze(fig4_data.phase_after.exp{exp}(:,1,ang))),circ_mean(squeeze(fig4_data.phase_after.exp{exp}(:,cycs,ang))),20,colorz(ang,:),'filled','MarkerEdgeColor','k')

        end
        G = G+1;

        ylim([-pi pi])
        xlim([-pi pi])
        title(['Delay: ',num2str(cycs*2),' ms'])

        xlabel('Start Phase')
        ylabel('End Phase')
        fig = subplot(4,3,G);
        hold on
        axis square
        fig.LineWidth = 2;
        if G == 2 | G == 5 | G == 8
            h = gca;
            h.XAxis.Color = 'none';
        end

        errorbar(angle_start_end(1,:),angle_start_end(3,:),sem_end(2,:),'Color','k','LineStyle','none','LineWidth',1)

        for i = 1:length(angle_start_end(3,:))

                scatter(angle_start_end(1,i),angle_start_end(3,i),20,colorz(i,:),'filled','MarkerEdgeColor','k')

                scatter(angle_start_end(1,i),angle_start_end(3,i),20,colorz(i,:),'filled','MarkerEdgeColor','k')


        end

        G = G+1;
        a = 1;
        for A = [330 60 150 240]
            xline(wrapToPi(deg2rad(A)),'Color',colors(a,:))
            a = a+1;
        end
        xlabel('Start Phase')
        ylabel('Phase Change')
        yline(0)
        text(.95*-pi,-.9*pi,'Delay')
        text(.95*-pi,.9*pi,'Advance')

        ylim([-pi pi])
        xlim([-pi pi])

        subplot(4,3,G);
        polarplot([0 circ_mean(angle_start_end(2,:)')],[0 (circ_r(angle_start_end(2,:)',R_end'))],'k','LineWidth',2)
        hold on
        h = gca;
        hold on
            B = 0.5;
            for i = 1:length(angle_start_end(3,:))
                polarscatter(angle_start_end(2,i),R_end(i),20,colorz(i,:),'filled','MarkerEdgeColor','k')
                
                B = B+.025;
                hold on
                
                if cycs>25
                    polarplot(circ_mean(squeeze(fig4_data.phase_after.exp{exp}(:,cycs-25:cycs,i))) ,circ_r(squeeze(fig4_data.phase_after.exp{exp}(:,cycs-25:cycs,i)),squeeze(fig4_data.R_after.exp{exp}(:,cycs-25:cycs,i))),'Color',colorz(i,:))
                else

                    polarplot(circ_mean(squeeze(fig4_data.phase_after.exp{exp}(:,1:cycs,i))) ,circ_r(squeeze(fig4_data.phase_after.exp{exp}(:,1:cycs,i)),squeeze(fig4_data.R_after.exp{exp}(:,1:cycs,i))),'Color',colorz(i,:))
                end
                if G >1
                    before(i) = angle_start_end(2,i);
                else
                    
                    hold on
                end
            end
        
        hold on

        rlim([0 1.1])
        
        G = G+1;

    end

saveas(gcf,[plot_dir,'\figure_4_experiment_',num2str(exp+2),'.svg'])
end


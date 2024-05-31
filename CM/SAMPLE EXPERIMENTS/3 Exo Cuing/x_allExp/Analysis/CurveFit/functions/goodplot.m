function goodplot(papersize, margin, fontsize)

    % function which produces a nice-looking plot
    % and sets up the page for nice printing
    if nargin == 0
        papersize = 8;
        margin = 0.5;
        fontsize = 18;
    elseif nargin == 1
        margin = 0.5;
        fontsize = 18;
    elseif nargin == 2
        fontsize = 18;
    end
    
    col3 = [255/255, 250/255, 245/255];
    
    set(get(gca,'xlabel'),'FontSize', fontsize, 'FontWeight', 'Bold');
    set(get(gca,'ylabel'),'FontSize', fontsize, 'FontWeight', 'Bold');
    set(get(gca,'title'),'FontSize', fontsize, 'FontWeight', 'Bold');
    box off; axis square;
    set(gca,'LineWidth',1);
    set(gca,'FontSize',8);
    set(gca,'FontWeight','Bold');
    set(gca,'color',col3);
    set(gcf,'color','w');
    
    %set(gcf,'PaperUnits','inches');
    %set(gcf,'PaperSize', [papersize papersize]);
    %set(gcf,'PaperPosition',[margin margin papersize-2*margin papersize-2*margin]);
    %set(gcf,'PaperPositionMode','Manual');

end
function [] = Marisize(fontSize, applytowholefigure)
%Caroline Myers
%The Carrasco Lab
%07/1/2018
%Inspired by Pascal Wallisch's 'Marisize' function. 
%This function applies a set of pre-determined properties to a figure you
%create. Makes the figure prettier. Subjectively. 
%Version history: none
%Usage: Marisize(fontsize, applytowholefigure) where "apply" is 0 or 1
box off
set(gca,'TickDir','out') %get ticks out
set(gca,'XScale', 'linear')%scale the x axis
set(gca,'fontsize',fontSize)%set fontsize to whatever you determine (arg 1)
set(gca,'fontweight','bold')%set font weight to bold
set(gca,'ticklength',[0.00 0.0]); %set tick length
%set(gcf,'markerfacecolor',[0 255 255]); %set tick length
set(gca,'layer','top')%layering
%axis square

if applytowholefigure == 1 %if applytowholefigure is turned on (arg 2)
%Applies to whole figure
temp = findall(gcf,'Type','text');%find texts
set(temp,'FontSize',fontSize);%set fontsize
set(temp,'FontWeight','bold');%set fontweight
set(temp,'FontName','Arial');%set font type
end
end

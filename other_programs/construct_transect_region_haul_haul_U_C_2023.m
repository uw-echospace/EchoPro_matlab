% construct transect_region_haul from exported .csv files, originally from
% EV files (US and CAN have different region names)
% function  out=construct_transect_region_haul(input_file_dir,output_filename)
% Created 11-07-2015
% Modified 10-29-2021 ==> exclude Age-0 Hake

clear

age1_included = 'yes';   % 'yes' or 'no'

%input_file_dir='N:\Survey.Acoustics\Survey Time Series Analysis\Historical Summary (for Kriging)\Exports\2019\';
%input_file_dir='N:\Survey.Acoustics\Projects & Analysis\EK80\EK60_EK80 comparison\Network EK60_EK80 conversion\Exports\2019\Sv_corrected (scenario 1 TABLE) On transect only\';
% input_file_dir='N:\Survey.Acoustics\2021 Hake Sum SH_NP\Post-cruise analysis\Exports\Export20211203\';
% input_file_dir='C:\Projects\EchoPro\EchoProGUI_Currrent\outputs\NASC_exports\Export20211201\';
input_file_dir='N:\Survey.Acoustics\Survey Time Series Analysis\Historical Summary (for Kriging)\Exports\2023\';
% output_filename='US&CAN_2019_transect_region_haul_age1+ auto.xlsx';
haul_offset0=200;
filetype='*(cells).csv';
var_name={'Tranect','Region ID','Trawl #','Region Name','Region Calss'};
files=dir([input_file_dir filetype]);
nf=length(files);           % number of transects
T_regID_haul_ind=0;

if strcmp(age1_included, 'yes')
    species_name={'Age-1 Hake','Hake','Hake Mix', 'Age-1 Hake Mix'};
    %output_filename='US&CAN_20_transect_region_haul_age1+ auto_final.xlsx';
    output_filename='US&CAN_2023_transect_region_haul_age1+ auto_draft.xlsx';
else
    species_name={'Hake','Hake Mix'};
    %output_filename='US&CAN_2019_transect_region_haul_age2+ auto_EK60_revised_final.xlsx';
    output_filename='US&CAN_2023_transect_region_haul_age2+ auto_draft.xlsx';
end

haul_offset=0;
tic
for i=1:nf
%for i=48:nf
    [dat, dat_str]=xlsread([input_file_dir files(i).name]);
    [dat2]=readtable([input_file_dir files(i).name]);  %issue with extra quotes, try reading in as readtable.
    if ~isempty(dat)
        [unique_reg_id, indA, indB]=unique(dat(:,1),'stable');  % same order as in original dat array
        disp(files(i).name)
        nr=length(unique_reg_id);
        region_name=char(dat_str(indA+1,2));  %datstr has a header
        region_class=char(dat_str(indA+1,3));
        datu=table();
        datu.region_name=dat2.Region_name(indA);
        datu.region_name=strrep(datu.region_name,'"','');  %removes all doublequotes
        %datu.region_name=regexprep(datu.region_name, '^"|"$', '')  %remove doublequotes from beginning and end - doesn't work because there is a space before the first doublequotes
        datu.region_name=regexprep(datu.region_name, '^ ', '');   %gets rid of initial space
        datu.region_class=dat2.Region_class(indA);
        indx=strfind(files(i).name,'T')+1;
        %     indx = 2;    % for 2019 EK80 --> EK60
        %     if ~isempty(indx) & ~strfind(files(i).name, 'Winter2017')   % exclude Winter 2017
        if ~isempty(indx)
            transect=[];
            T4=str2num(files(i).name(indx:indx+3));
            T3=str2num(files(i).name(indx:indx+2));
            T2=str2num(files(i).name(indx:indx+1));
            T1=str2num(files(i).name(indx));
            if ~isempty(T4)
                transect=T4;
            elseif ~isempty(T3)
                transect=T3;
            elseif ~isempty(T2)
                transect=T2;
            elseif ~isempty(T1)
                transect=T1;
            end
        else   % 2017 winter
            if  i == 1
                transect0 = (str2num(files(i).name(12:13)) - 1)*31 + str2num(files(i).name(15:16));   %Year-Day as a reference value
            end
            transect = (str2num(files(i).name(12:13)) - 1)*31 + str2num(files(i).name(15:16)) - transect0 + 1;   % relative Day
        end
        i,transect  %display iteration, transect
        if ~isempty(transect)
            %         if transect == 1
            %             disp(transect)
            %         end
            
            for j=1:nr
                adultpat="h"+digitsPattern(1,3);  %pattern to look for adult hake where it is an h immediately followed by a (1-3 digit)number.  Meant to exlude "he" which is being used for herring in Canada
                %Should still work despite capturing age-1s since Chu's original algorithm would have let age-1s in here.
                %adult_ind=strfind(lower(datu.region_name{j}(1)),'h')+1;
                adult_ind=strfind(lower(datu.region_name{j}),adultpat)+1;
                age1_ind=strfind(lower(datu.region_name{j}),'h1a')+3;
                age1_mix_ind=strfind(lower(datu.region_name{j}),'h1am')+4;
                if ~isempty(age1_ind)| ~isempty(age1_mix_ind)  % if it's age1/age1_mix hake?
                    adult_ind = [];
                end
                mix_ind=strfind(lower(datu.region_name{j}),'hm')+2;
                adult_ind1=strfind(lower(datu.region_name{j}),'hake')+4;
                mix_ind1=strfind(lower(datu.region_name{j}),'hake_mix')+8;  % SCB
                if  isempty(adult_ind1)
                    adult_ind=adult_ind;
                else
                    adult_ind=adult_ind1;
                end
                if strcmp(age1_included, 'yes')
                    %                 age1_mix_ind=strfind(lower(datu.region_name{j}),'h1am')+4;
                    if ~isempty(age1_mix_ind)
                        %                 if isempty(age1_mix_ind)
                        %                     age1_ind=strfind(lower(datu.region_name{j}),'h1a')+3;
                        %                 else
                        age1_ind=[];
                    end
                else
                    age1_ind= [];
                    age1_mix_ind=[];
                end
                present_ind=strfind(lower(datu.region_name{j}),'hp');     % hake present
                hake_age0_ind=strfind(lower(datu.region_name{j}),'h0a');  % age0 hake
                herring_ind=strfind(lower(datu.region_name{j}),'her');    % herring
                rockfish_ind=strfind(lower(datu.region_name{j}),'rock');  % rockfish
                myctophid_ind=strfind(lower(datu.region_name{j}),'myc');  % myctophids
                ind=[];
                if ~isempty(age1_ind) & isempty(present_ind)
                    ind=age1_ind;
                elseif ~isempty(mix_ind) & isempty(present_ind)
                    ind=mix_ind;
                elseif ~isempty(mix_ind1)
                    ind=mix_ind1;
                elseif ~isempty(age1_mix_ind)
                    ind=age1_mix_ind;
                elseif ~isempty(adult_ind) & isempty(present_ind) & isempty(herring_ind) & isempty(rockfish_ind) & isempty(myctophid_ind) & isempty(hake_age0_ind)
                    ind=adult_ind;
                else
                    for ij=1:size(species_name,2)      % loop through species
                        % species read from the cell excel file and conver to lower case
                        species_name0=lower(char(region_class(j,:)));
                        species_name1=[' "' lower(char(species_name(ij))) '"'];
                        ind_s_ij=strmatch(species_name1,species_name0);
                        ind=[ind; ind_s_ij];
                    end
                end
                % determine haul number
                %tempregion_name=strrep(datu.region_name{j},'"','');  %take out double quotes
                %stripregion_name=strrep(tempregion_name,' ','');  %take out extra spaces
                %stripregion_name=dat2.datu.region_name{j};
                if ~isempty(ind)
                    fnl=length(datu.region_name{j});
                    %fnl=length(stripregion_name);
                    haul=[];
                    if fnl >= ind+2
                        %h3=str2num(region_name(j,ind:ind+2));
                        h3=str2num(datu.region_name{j}(ind:ind+2));
                        ind1=ind+3;
                    else
                        h3=[];
                    end
                    if fnl >= ind+1 & isempty(h3)
                        %h2=str2num(region_name(j,ind:ind+1));
                        h2=str2num(datu.region_name{j}(ind:ind+1));
                        ind1=ind+2;
                    else
                        h2=[];
                    end
                    if fnl >= ind & isempty(h3)& isempty(h2)
                        %h1=str2num(region_name(j,ind));
                        h1=str2num(datu.region_name{j}(ind));
                        ind1=ind+1;
                    else
                        h1=[];
                    end
                    if ~isempty(h3)
                        haul=h3;
                    elseif ~isempty(h2)
                        haul=h2;
                    elseif ~isempty(h1)
                        haul=h1;
                    end
                    if isempty(haul)
                        haul=NaN;
                        fprintf('********************\n')
                    else
                        country_letter=lower(datu.region_name{j}(ind1));
                        if country_letter == 'c'
                            haul_offset=haul_offset0;
                        else
                            haul_offset=0;
                        end
                    end
                    %                 if transect == 56 & unique_reg_id(j) == 48
                    %                     disp(j)
                    %                 end
                    haul=haul+haul_offset;
                    disp([num2str(transect) '  ' num2str(unique_reg_id(j)) ' ' num2str(haul) ' ' datu.region_name{j}])
                    T_regID_haul_ind=T_regID_haul_ind+1;
                    T_regID_haul(T_regID_haul_ind,1:3)=[transect unique_reg_id(j) haul];
                    Region_name{T_regID_haul_ind,1}=datu.region_name{j};
                    Region_class{T_regID_haul_ind,1}=region_class(j,:);
                end
            end
        end
    end
end
[sorted_T_regID_haul,sort_ind]=sort(T_regID_haul(:,1));
fprintf('Transect  RegionID  Haul#  RegionName\n')
xlswrite(output_filename,var_name,1,'A1')
xlswrite(output_filename,T_regID_haul(sort_ind,:),1,'A2')
xlswrite(output_filename,Region_name(sort_ind),1,'D2')
xlswrite(output_filename,Region_class(sort_ind),1,'E2')
toc

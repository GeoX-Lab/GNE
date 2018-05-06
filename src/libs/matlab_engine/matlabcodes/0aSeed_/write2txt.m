     function write2txt(mat,txtname)

%mat:the variable you want to write in txt
%tname:the txt name you output

%warning: 当你使用这个函数名的时候，请定义需要保留小数的位置以及个数
% ind=[0 0 0 0];

row=size(mat,1);
col=size(mat,2);

eval(['fid=fopen(''',txtname,'.txt'',','''a''',')']);
for i=1:row 
    for j=1:col
        if j<col 
%             && isempty(intersect(j,ind))
            fprintf(fid,'%d ',mat(i,j));
        end
%         if ~isempty(intersect(j,ind))
%             fprintf(fid,'%.11g ',mat(i,j));  '/
%         end
        if j==col
            fprintf(fid,'%d\r\n',mat(i,j));
        end
        end
    end 
fclose(fid);
end
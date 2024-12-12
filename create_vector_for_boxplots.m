function [v, var1, var2]=create_vector_for_boxplots(DB1,DB2,vec_col,scale)

v1=double(DB1(:,vec_col))*scale;
v2=double(DB2(:,vec_col))*scale;

size_diff=abs(size(v2,1)-size(v1,1));
if size(v1,1)<size(v2,1)
    var1=[v1; nan(size_diff,size(v1,2))];    var2=v2;
elseif size(v1,1)>size(v2,1)
    var2=[v2; nan(size_diff,size(v2,2))];    var1=v1;
else
    var1=v1; var2=v2;
end

v=[var1 var2];
v(~isfinite(v))=nan;


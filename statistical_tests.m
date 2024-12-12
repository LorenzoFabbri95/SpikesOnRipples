function all_data=statistical_tests(input)
pvalues=[];
comp1=[];
comp2=[];
number_of_inputs=size(input,2);

comp1_name=[];
comp2_name=[];
test=[];

% wilcoxon signed rank on the inputs
for i=1:1:number_of_inputs
    for j=i+1:1:number_of_inputs
        input1=table2array(input(:,i));
        input2=table2array(input(:,j));
        try
            pvalues_temp=signrank(input1(~isnan(input1)),input2(~isnan(input2)));
            test = vertcat(test,"signrank");
        catch
            pvalues_temp=ranksum(input1(~isnan(input1)),input2(~isnan(input2)));
            test = vertcat(test,"ranksum");
        end
        pvalues=[pvalues;pvalues_temp];
        comp1=[comp1; i];
        comp2=[comp2; j];
        temp_c1_name=string(input.Properties.VariableNames(i));
        temp_c2_name=string(input.Properties.VariableNames(j));
        comp1_name=vertcat(comp1_name,temp_c1_name);
        comp2_name=vertcat(comp2_name,temp_c2_name);
    end
end

% wilcoxon signed rank on the inputs


all_data=table;
all_data.var1=comp1_name;
all_data.var2=comp2_name;
all_data.comp1=comp1;
all_data.comp2=comp2;
all_data.p_values=pvalues;
all_data.test_type=test;


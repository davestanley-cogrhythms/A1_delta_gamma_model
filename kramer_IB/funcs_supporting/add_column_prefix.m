function spec_out = add_column_prefix(spec,column_prefix_name)
    spec_out = spec;
    for i = 1:length(spec_out.populations)
        spec_out.populations(i).name = [column_prefix_name spec_out.populations(i).name];
    end
    for i = 1:length(spec_out.connections)
        mydir = spec_out.connections(i).direction;
        foo = strfind(mydir,'->');
        pre = mydir(1:foo-1);
        post = mydir(foo+2:end);
        spec_out.connections(i).direction = [column_prefix_name pre '->' column_prefix_name post];
    end
end
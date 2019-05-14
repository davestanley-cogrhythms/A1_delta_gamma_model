function pop_struct_out = add_column_prefix_popstruct(pop_struct,column_prefix_name)

    pop_struct_out = struct;
    myfields = fields(pop_struct);
    for i = 1:length(myfields)
        f = myfields{i};
        pop_struct_out.(['N' column_prefix_name f(2:end)]) = pop_struct.(f);
    end
    
end
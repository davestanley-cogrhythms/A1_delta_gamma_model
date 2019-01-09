

function save_specs(spec_all,outpath)

% Save spec file

if ~isempty(spec_all)
    save(fullfile(outpath,'spec_all.mat'),'spec_all');
end

end
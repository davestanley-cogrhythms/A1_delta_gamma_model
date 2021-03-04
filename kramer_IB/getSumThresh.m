function getSumThresh(sim_name, x0)

[x, fval, exitflag, output] = fminsearch(@(x) calcVPdist(x(1), x(2), sim_name, 2, 300), x0, struct('Display', 'iter'));

save(sprintf('%s_x0_%g_%g_sumThresh.mat', sim_name, x0), 'x', 'fval', 'exitflag', 'output')

end

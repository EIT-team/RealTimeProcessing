function X = Reconstruct(dVs,BV0,J,U,S,V)


all_dZ=[];
% Puts the right sign for the measured boundary voltages changes CRITICAL!!!!

    dVs(BV0<0) =  -dVs(BV0<0);
    all_dZ = dVs;

lambda = logspace(-8,-4,20);
%lambda = 1e-5;
nsamples = size(all_dZ,1);



    % Cross validation
    [X,cv_error] = tikhonov_CV(J,all_dZ,lambda,nsamples,U,S,V,0);
    
%     [a,opt] = min(cv_error);
%     sv = diag(S);
    
    
%     dev = zeros(size(X));
%     Noise = .5*1e-6*randn(nsamples,500);
%     for i=1:size(X,2)
%         % no noise
%         sv_i = sv+lambda(opt(i))./sv;
%             Jinv = V*diag(1./sv_i)*U';
%         
%         dev(:,i) = std(Jinv*Noise,1,2);
%     end
% 
% X=X./dev;
% 
%     for i=1:size(X,2)
%     writeVTKcell([PicPath num2str(i)],tri(:,1:4),vtx(:,1:3),X(:,i));
% 
%     end

end

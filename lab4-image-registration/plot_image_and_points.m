function [] = plot_image_and_points(I, xs, ys, varargin)
    ax = gca();
    imshow(I);
    % Expand axes a bit, to allow for out-of-image points
    ax.XLim = ax.XLim + 0.15*range(ax.XLim).*[-1,1];
    ax.YLim = ax.YLim + 0.15*range(ax.YLim).*[-1,1];
    h = ishold(ax); % Store hold-state
    hold(ax, 'on')
    ax.Clipping = "off"; % Show points outside the image as well
    scatter(xs, ys, varargin{:}); 
    if (~h), hold(ax, 'off'); end % Restore hold-state
end


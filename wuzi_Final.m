clc;
clear;

% 加载游戏引擎
my_scene = simpleGameEngine('Gomoku.png', 79, 84);

% 定义棋子
empty_sprite = 1;
black_sprite = 2; % 玩家棋子
white_sprite = 3; % AI 棋子 

% 游戏关卡循环        
for level = 1:3
    if level == 1
        % 第一关：三子棋（改为9x9）
        disp('Level 1: Three-in-a-row');
        board_size = 9; % 改为9x9棋盘
        win_condition = 3; % 三子连线获胜
    elseif level == 2
        % 第二关：五子棋
        disp('Level 2: Five-in-a-row');
        board_size = 15; % 15x15棋盘
        win_condition = 5; % 五子连线获胜
    else
        % 第三关：五子棋 + AI 对手
        disp('Level 3: Five-in-a-row with AI opponent');
        board_size = 15; % 15x15棋盘
        win_condition = 5; % 五子连线获胜
        ai_enabled = true; % 启用 AI
    end

    % 初始化棋盘
    board_display = empty_sprite * ones(board_size, board_size);
    drawScene(my_scene, board_display);
    title(['Level ' num2str(level) ' Board State']);

    % 初始化游戏状态
    current_sprite = black_sprite; % 黑棋先手
    game_over = false;             % 游戏结束标志
    move_count = 0;                % 已下棋步数
    
    % 整个循环的作用是：

    %确定当前玩家是谁（黑棋或白棋）。
    %根据当前关卡和玩家（或 AI）的轮流，决定是让 AI 走棋还是玩家走棋。
    %玩家通过鼠标点击选择一个空位来落子，AI 通过算法选择一个位置来落子。
    %更新棋盘状态，显示新的棋盘，并记录已下的步数。
    %直到满足胜利条件或棋盘已满，游戏结束。

    % 游戏主循环
    while ~game_over % 这个代码会重复执行，直到game_over为true 标记游戏是否结束
        if current_sprite == black_sprite
            player_name = 'Black'; % 判断当前玩家是谁，来定义玩家
        else
            player_name = 'White';
        end

        disp([player_name '''s turn.']);

        if level == 3 && current_sprite == white_sprite % 第三关且轮到白棋的时候
            % AI 行动逻辑
            pause(1); % AI 思考时间 1 秒
            % 调用AI的函数，返回AI落子位置
            [row, col] = aiMove(board_display, black_sprite, white_sprite, win_condition);
        else
            % 玩家行动逻辑
            [row, col] = getMouseInput(my_scene);
            while board_display(row, col) ~= empty_sprite
                disp('Invalid move! Please select an empty spot.');
                [row, col] = getMouseInput(my_scene);
            end
        end

        % 下棋
        board_display(row, col) = current_sprite; % 将当前玩家所执的棋子放到对应的[row,col]位置上
        drawScene(my_scene, board_display); % 更新棋盘
        move_count = move_count + 1; % 增加已下的步数，用于判断是否为平局

        % 检查胜利条件
        [win, win_positions] = checkWin(board_display, row, col, current_sprite, win_condition);
        if win
            if current_sprite == black_sprite
                winner = 'Black';  % 更改为 'Black' 以对应棋子颜色
            else
                winner = 'White';  % 更改为 'White' 以对应棋子颜色
            end
            disp([winner ' wins!']);
            title([winner ' Wins!']);
            % 动态特效：闪烁获胜棋子
            flashWinner(board_display, my_scene, win_positions, current_sprite);
            game_over = true;
        elseif all(board_display(:) ~= empty_sprite)
            disp('The game is a draw!');
            title('Draw!');
            game_over = true;
        else
            % 切换到下一位玩家
            if current_sprite == black_sprite
                current_sprite = white_sprite;
            else
                current_sprite = black_sprite;
            end
        end
    end

    disp(['Level ' num2str(level) ' is over!']);
    if level == 2
        disp('Proceeding to Level 3: Five-in-a-row with AI opponent...');
    else
        disp('Game completed! Thanks for playing.');
    end
end

disp('Game Over!');

% 胜利检测函数
function [win, win_positions] = checkWin(board, row, col, sprite, win_condition)
    % 检查水平、垂直和两条对角线方向是否满足连线条件
    directions = [
        0 1;   % 水平
        1 0;   % 垂直
        1 1;   % 对角线 \
        1 -1   % 对角线 /
    ];
    win = false;
    win_positions = [];
    for d = 1:size(directions, 1)
        count = 1; % 当前连线棋子的计数
        positions = [row, col]; % 记录连线棋子位置
        for step = [-1, 1] % 双向检查
            r = row;
            c = col;
            while true
                r = r + step * directions(d, 1);
                c = c + step * directions(d, 2);
                if r >= 1 && r <= size(board, 1) && c >= 1 && c <= size(board, 2) && board(r, c) == sprite
                    count = count + 1;
                    positions = [positions; r, c]; % 添加到连线位置
                else
                    break;
                end
            end
        end
        if count >= win_condition
            win = true;
            win_positions = positions; % 保存获胜棋子位置
            return;
        end
    end
end

% AI 行动逻辑
function [row, col] = aiMove(board, player_sprite, ai_sprite, win_condition)
    % 优先级 1: 自己能获胜
    [row, col] = findWinningMove(board, ai_sprite, win_condition);
    if ~isempty(row)
        return;
    end

    % 优先级 2: 阻止对手获胜
    [row, col] = findWinningMove(board, player_sprite, win_condition);
    if ~isempty(row)
        return;
    end

    % 优先级 3: 尝试在某方向上增加连线
    [row, col] = findStrategicMove(board, ai_sprite);
    if ~isempty(row)
        return;
    end

    % 如果没有特别优先级，随机落子
    empty_positions = find(board == 1);
    random_index = randi(length(empty_positions));
    [row, col] = ind2sub(size(board), empty_positions(random_index));
end

% 查找能获胜的落子
function [row, col] = findWinningMove(board, sprite, win_condition)
    board_size = size(board, 1);
    for r = 1:board_size
        for c = 1:board_size
            if board(r, c) == 1
                board(r, c) = sprite;
                [win, ~] = checkWin(board, r, c, sprite, win_condition);
                if win
                    row = r; col = c;
                    board(r, c) = 1; % 恢复棋盘
                    return;
                end
                board(r, c) = 1; % 恢复棋盘
            end
        end
    end
    row = []; col = [];
end

% 查找战略性落子（尝试连线）
function [row, col] = findStrategicMove(board, sprite)
    board_size = size(board, 1);
    for r = 1:board_size
        for c = 1:board_size
            if board(r, c) == 1
                % 定义：关于（0，0）的9宫格的方向数组
                neighbors = [-1 0; 1 0; 0 -1; 0 1; -1 -1; 1 1; -1 1; 1 -1];
                for n = 1:size(neighbors, 1) % 遍历数组的9个方向
                    % 内部逻辑： 是走当前遍历到（执行的）方向
                    % nr：代表行
                    % nc：代表列
                    nr = r + neighbors(n, 1);
                    nc = c + neighbors(n, 2);
                    % 如果越界（棋子要落在当前棋盘大小内）
                    if nr >= 1 && nr <= board_size && nc >= 1 && nc <= board_size && board(nr, nc) == sprite
                        row = r; col = c; % otherwise 退回来 若成立，就继续走这一步
                        return;
                    end
                end
            end
        end
    end
    row = []; col = [];
end

% 动态特效函数：闪烁获胜棋子
function flashWinner(board, my_scene, win_positions, sprite)
    for i = 1:5 % 闪烁5次
        % 第一次：清空获胜位置
        for pos = 1:size(win_positions, 1)
            board(win_positions(pos, 1), win_positions(pos, 2)) = 1; % 置空
        end
        drawScene(my_scene, board);
        pause(0.2);
        % 第二次：恢复获胜棋子
        for pos = 1:size(win_positions, 1)
            board(win_positions(pos, 1), win_positions(pos, 2)) = sprite; % 恢复
        end
        drawScene(my_scene, board);
        pause(0.2);
    end
end
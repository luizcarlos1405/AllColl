-- AllColl is the collision handler

vector = require "../libs/vector-light"

class allcoll
    new: =>
        @shapes = {}

    -- Retorna coll, mtv
    -- coll é boleano se houve ou não a colisão, mtv é uma table que é um vetor e contém
    -- mtv.x o quanto é necessário mover em x para separ os shapes e mtv.y semelhante
    -- O argumento fix é um aabb que não se moverá e o move é um aabb que se moverá para separá-los
    isColl: (fix, move) =>
        mtv = {x:0, y:0}

        -- Colisão aabb vs aabb
        if fix.type == "aabb" and move.type == "aabb"
            coll = (fix.x + fix.w - fix.offset.x > move.x - move.offset.x and
                move.x + move.w - move.offset.x > fix.x - fix.offset.x) and
                (fix.y + fix.h - fix.offset.y > move.y - move.offset.y and
                move.y + move.h - move.offset.y > fix.y - fix.offset.y)

            if coll
                top    = fix.y - (move.y + move.h) - fix.offset.y + move.offset.y
                bottom = (fix.y + fix.h) - move.y - fix.offset.y + move.offset.y
                left   = fix.x - (move.x + move.w) - fix.offset.x + move.offset.x
                right  = (fix.x + fix.w) - move.x - fix.offset.x + move.offset.x

                min = math.min(math.abs(top), math.abs(bottom), math.abs(left), math.abs(right))

                if     min == math.abs(top) then mtv = {x:0, y:top}
                elseif min == math.abs(bottom) then mtv = {x:0, y:bottom}
                elseif min == math.abs(left) then mtv = {x:left, y:0}
                elseif min == math.abs(right) then mtv = {x:right, y:0}

                return true, mtv

            return false, mtv

        -- Trata colisão entre dois rectangles
        elseif fix.type == "rectangle" and move.type == "rectangle"
            Vx, Vy      = nil, nil
            mtv         = {}
            proj        = nil
            overlap     = nil
            minOverlap  = nil
            fixMinProj  = nil
            fixMaxProj  = nil
            moveMinProj = nil
            moveMaxProj = nil

            -- Considerando os pontos do primeiro shape
            for i = 1, #fix.points
                -- Calcula vetor na direção da aresta do polígono
                if i == #fix.points
                    Vx, Vy = vector.sub(fix.points[1].x, fix.points[1].y, fix.points[i].x, fix.points[i].y)
                else
                    Vx, Vy = vector.sub(fix.points[i+1].x, fix.points[i+1].y, fix.points[i].x, fix.points[i].y)
                -- Calcula vetor perpenducular à essa aresta
                Vx, Vy = vector.perpendicular(Vx, Vy)
                -- Calcula o vetor unitária na mesma direção e sentido do vetor perpendicular à aresta
                Vx, Vy = vector.normalize(Vx, Vy)
                -- Projeta todos os pontos desse polígono nesse vetor unitário apenas fazendo o dot product
                -- Também guarda o maior e o menor valor projetado
                for j = 1, #fix.points
                    if j == 1
                        -- Inicializa o mínimo e o máximo com a primeira projeção
                        fixMinProj = vector.dot(fix.points[j].x, fix.points[j].y, Vx, Vy)
                        fixMaxProj = fixMinProj
                    else
                        -- Atualiza valores de mínimo e máxima projeção
                        proj = vector.dot(fix.points[j].x, fix.points[j].y, Vx, Vy)
                        fixMinProj = math.min(proj, fixMinProj)
                        fixMaxProj = math.max(proj, fixMaxProj)
                -- Faz-se o mesmo com o segundo shape
                for j = 1, #move.points
                    if j == 1
                        -- Inicializa o mínimo e o máximo com a primeira projeção
                        moveMinProj = vector.dot(move.points[j].x, move.points[j].y, Vx, Vy)
                        moveMaxProj = moveMinProj
                    else
                        -- Atualiza valores de mínimo e máxima projeção
                        proj = vector.dot(move.points[j].x, move.points[j].y, Vx, Vy)
                        moveMinProj = math.min(proj, moveMinProj)
                        moveMaxProj = math.max(proj, moveMaxProj)
                -- Se não houver olverlapping eles não estão colidindo e já podemos retornar falso
                if fixMaxProj < moveMinProj or moveMaxProj < fixMinProj
                    return false, {x:0, y:0}
                -- Calcula o overlapping
                auxOverlap1 = fixMaxProj - moveMinProj
                auxOverlap2 = fixMinProj - moveMaxProj
                if math.abs(auxOverlap1) < math.abs(auxOverlap2)
                    overlap = auxOverlap1
                else
                    overlap = auxOverlap2

                -- overlap = math.min(math.abs(fixMaxProj - moveMinProj), math.abs(fixMinProj - moveMaxProj))

                -- Inicializa vetor untiário que aponta pra sepração dos shapes se for o primeiro pontos
                if i == 1
                    minOverlap = overlap
                    mtv = {Vx, Vy}
                -- Se esse overlap for menor que o guardado em minOverlap, então atualiza minOverlap
                -- Também atualiza o vetor unitário que aponta pra sepração dos shapes
                elseif math.abs(minOverlap) > math.abs(overlap)
                    minOverlap = overlap
                    mtv = {Vx, Vy}

            -- Agora, considerando os pontos do segundo shape
            for i = 1, #move.points
                -- Calcula vetor na direção da aresta do polígono
                if i == #move.points
                    Vx, Vy = vector.sub(move.points[1].x, move.points[1].y, move.points[i].x, move.points[i].y)
                else
                    Vx, Vy = vector.sub(move.points[i+1].x, move.points[i+1].y, move.points[i].x, move.points[i].y)
                -- Calcula vetor perpenducular à essa aresta
                Vx, Vy = vector.perpendicular(Vx, Vy)
                -- Calcula o vetor unitária na mesma direção e sentido do vetor perpendicular à aresta
                Vx, Vy = vector.normalize(Vx, Vy)
                -- Projeta todos os pontos desse polígono nesse vetor unitário apenas fazendo o dot product
                -- Também guarda o maior e o menor valor projetado
                for j = 1, #move.points
                    -- Atualiza valores de mínimo e máxima projeção
                    proj = vector.dot(move.points[i].x, move.points[i].y, Vx, Vy)
                    moveMinProj = math.min(proj, moveMinProj)
                    moveMaxProj = math.max(proj, moveMaxProj)
                -- Faz-se o mesmo com o segundo shape
                for j = 1, #move.points
                    -- Atualiza valores de mínimo e máxima projeção
                    proj = vector.dot(move.points[i].x, move.points[i].y, Vx, Vy)
                    moveMinProj = math.min(proj, moveMinProj)
                    moveMaxProj = math.max(proj, moveMaxProj)
                -- Se não houver olverlapping eles não estão colidindo e já podemos retornar falso
                if fixMaxProj < moveMinProj or moveMaxProj < fixMinProj
                    return false, {x:0, y:0}
                -- Calcula o overlapping
                auxOverlap1 = fixMaxProj - moveMinProj
                auxOverlap2 = fixMinProj - moveMaxProj
                if math.abs(auxOverlap1) < math.abs(auxOverlap2)
                    overlap = auxOverlap1
                else
                    overlap = auxOverlap2

                -- overlap = math.min(math.abs(fixMaxProj - moveMinProj), math.abs(fixMinProj - moveMaxProj))

                -- Inicializa vetor untiário que aponta pra sepração dos shapes se for o primeiro pontos
                if i == 1
                    minOverlap = overlap
                    mtv = {Vx, Vy}
                -- Se esse overlap for menor que o guardado em minOverlap, então atualiza minOverlap
                -- Também atualiza o vetor unitário que aponta pra sepração dos shapes
                elseif math.abs(minOverlap) > math.abs(overlap)
                    minOverlap = overlap
                    mtv = {Vx, Vy}

            -- Finalmente, calcula-se o mtv real
            print "unit x: #{mtv[1]} y: #{mtv[2]}"
            print "minOverlap: #{minOverlap}"
            mtv.x, mtv.y = vector.mul(minOverlap, mtv[1], mtv[2])
            print "mtv.x #{mtv.x} mtv.y #{mtv.y}"
            return true, mtv

    -- Adiciona um shape à table de shapes
    addShape: (shape) =>
        table.insert(@shapes, shape)

return allcoll

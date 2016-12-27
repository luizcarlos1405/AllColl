-- AllColl is the collision handler

vector = require "../libs/vector-light"

class allcoll
    new: =>
        @shapes = {}
        @gravity = {x: 0, y: 0}

    setGravity: (gx, gy) =>
        @gravity = {x: gx, y: gy}

    -- Retorna coll, mtv
    -- coll é boleano se houve ou não a colisão, mtv é uma table que é um vetor e contém
    -- mtv.x o quanto é necessário mover em x para separ os shapes e mtv.y semelhante
    -- O argumento fix é um aabb que não se moverá e o move é um aabb que se moverá para separá-los
    isColliding: (fix, move) =>
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

        elseif fix.type == "circle" and move.type == "circle"
            Vx, Vy = move.x - fix.x, move.y - fix.y
            distance = vector.len(Vx, Vy)

            if distance < fix.r + move.r
                Vx, Vy = vector.normalize(Vx, Vy)
                mtv =
                    x: Vx * (fix.r + move.r - distance)
                    y: Vy * (fix.r + move.r - distance)
                return true, mtv
            else
                return false, {x: 0, y:0}

        -- Colisão Polygon vs Polygon ou Polygon vs Rectangle
        elseif fix.type ~= "circle" and move.type ~= "circle"
            overlap         = nil
            minOverlap1     = nil
            minOverlap2     = nil
            mtv, mtv1, mtv2 = {}

            -- Processa-se os eixos do shape fix e do move
            -- Cancela processamento e retorna caso algum retorne 0
            if fix.type == "polygon"
                minOverlap1, mtv1 = @processAllPoints(fix, move)
            else
                minOverlap1, mtv1 = @processRectanglePoints(fix, move)
            if minOverlap1 == 0
                return false, {x: 0, y:0}

            if move.type == "polygon"
                minOverlap2, mtv2 = @processAllPoints(move, fix)
            else
                minOverlap2, mtv2 = @processRectanglePoints(move, fix)
            if minOverlap2 == 0
                return false, {x: 0, y:0}

            -- Dos dois overlaps mínimos referentes aos shapes fix e move, pega-se o menor
            if math.abs(minOverlap1) <= math.abs(minOverlap2)
                mtv = mtv1
                overlap = minOverlap1
            else
                -- Caso seja identificado o menor overlap no shape move, deve-se usar o oposto
                -- do mtv isso se deve à inversão do shape base
                mtv = {-mtv2[1], -mtv2[2]}
                overlap = minOverlap2

            -- Finalmente, calcula-se o mtv real
            mtv.x, mtv.y = vector.mul(overlap, mtv[1], mtv[2])

            return true, mtv

    -- Adiciona um shape à table de shapes
    addShape: (shape) =>
        table.insert(@shapes, shape)

    -- Retorna a projeção mínima e o MTV em relação aos eixos perpendiculares
    -- Relativos a S1
    processAllPoints: (S1, S2) =>
        mtv        = {0, 0}
        proj       = 0
        Vx, Vy     = nil, nil
        overlap    = 0
        S1MinProj  = nil
        S1MaxProj  = nil
        S2MinProj  = nil
        S2MaxProj  = nil
        minOverlap = nil
        -- Considerando os pontos do primeiro shape
        for i = 1, #S1.points
            -- Calcula vetor na direção da aresta do polígono
            if i == #S1.points
                Vx, Vy = vector.sub(S1.points[1].x, S1.points[1].y, S1.points[i].x, S1.points[i].y)
            else
                Vx, Vy = vector.sub(S1.points[i+1].x, S1.points[i+1].y, S1.points[i].x, S1.points[i].y)

            -- Calcula vetor perpenducular à essa aresta
            Vx, Vy = vector.perpendicular(Vx, Vy)
            -- Calcula o vetor unitária na mesma direção e sentido do vetor perpendicular à aresta
            Vx, Vy = vector.normalize(Vx, Vy)

            -- Projeta todos os pontos desse polígono nesse vetor unitário apenas fazendo o dot product
            -- Também guarda o maior e o menor valor projetado
            for j = 1, #S1.points
                if j == 1
                    -- Inicializa o mínimo e o máximo com a primeira projeção
                    S1MinProj = vector.dot(S1.points[j].x, S1.points[j].y, Vx, Vy)
                    S1MaxProj = S1MinProj
                else
                    -- Atualiza valores de mínimo e máxima projeção
                    proj = vector.dot(S1.points[j].x, S1.points[j].y, Vx, Vy)
                    S1MinProj = math.min(proj, S1MinProj)
                    S1MaxProj = math.max(proj, S1MaxProj)
            -- Faz-se o mesmo com o segundo shape
            for j = 1, #S2.points
                if j == 1
                    -- Inicializa o mínimo e o máximo com a primeira projeção
                    S2MinProj = vector.dot(S2.points[j].x, S2.points[j].y, Vx, Vy)
                    S2MaxProj = S2MinProj
                else
                    -- Atualiza valores de mínimo e máxima projeção
                    proj = vector.dot(S2.points[j].x, S2.points[j].y, Vx, Vy)
                    S2MinProj = math.min(proj, S2MinProj)
                    S2MaxProj = math.max(proj, S2MaxProj)

            -- Se não houver overlapping eles não estão colidindo e já podemos retornar falso
            if S1MaxProj < S2MinProj or S2MaxProj < S1MinProj
                return 0, {0, 0}
            -- Calcula o overlapping
            auxOverlap1 = S1MaxProj - S2MinProj
            auxOverlap2 = S1MinProj - S2MaxProj
            if math.abs(auxOverlap1) < math.abs(auxOverlap2)
                overlap = auxOverlap1
            else
                overlap = auxOverlap2

            -- Inicializa vetor untiário que aponta pra sepração dos shapes se for o primeiro pontos
            if i == 1
                minOverlap = overlap
                mtv = {Vx, Vy}
            -- Se esse overlap for menor que o guardado em minOverlap, então atualiza minOverlap
            -- Também atualiza o vetor unitário que aponta pra sepração dos shapes
            elseif math.abs(overlap) < math.abs(minOverlap)
                minOverlap = overlap
                mtv = {Vx, Vy}

        return minOverlap, mtv
    -- Usado para comprar com os eixos perpendiculares de um rectangle um um aabb
    processRectanglePoints: (S1, S2) =>
        mtv        = {0, 0}
        proj       = 0
        Vx, Vy     = nil, nil
        overlap    = 0
        S1MinProj  = nil
        S1MaxProj  = nil
        S2MinProj  = nil
        S2MaxProj  = nil
        minOverlap = nil
        S1points   = {
            {x: S1.points[1].x, y:S1.points[1].y}
            {x: S1.points[2].x, y:S1.points[2].y}
            {x: S1.points[4].x, y:S1.points[4].y}
        }
        -- Considerando os pontos do primeiro shape
        for i = 1, 2
            -- Calcula vetor na direção da aresta do polígono
            if i == 1
                Vx, Vy = vector.sub(S1points[2].x, S1points[2].y, S1points[1].x, S1points[1].y)
            else
                Vx, Vy = vector.sub(S1points[3].x, S1points[3].y, S1points[1].x, S1points[1].y)

            -- Calcula vetor perpenducular à essa aresta
            Vx, Vy = vector.perpendicular(Vx, Vy)
            -- Calcula o vetor unitária na mesma direção e sentido do vetor perpendicular à aresta
            Vx, Vy = vector.normalize(Vx, Vy)

            -- Projeta todos os pontos desse polígono nesse vetor unitário apenas fazendo o dot product
            -- Também guarda o maior e o menor valor projetado
            for j = 1, #S1.points
                if j == 1
                    -- Inicializa o mínimo e o máximo com a primeira projeção
                    S1MinProj = vector.dot(S1.points[j].x, S1.points[j].y, Vx, Vy)
                    S1MaxProj = S1MinProj
                else
                    -- Atualiza valores de mínimo e máxima projeção
                    proj = vector.dot(S1.points[j].x, S1.points[j].y, Vx, Vy)
                    S1MinProj = math.min(proj, S1MinProj)
                    S1MaxProj = math.max(proj, S1MaxProj)
            -- Faz-se o mesmo com o segundo shape
            for j = 1, #S2.points
                if j == 1
                    -- Inicializa o mínimo e o máximo com a primeira projeção
                    S2MinProj = vector.dot(S2.points[j].x, S2.points[j].y, Vx, Vy)
                    S2MaxProj = S2MinProj
                else
                    -- Atualiza valores de mínimo e máxima projeção
                    proj = vector.dot(S2.points[j].x, S2.points[j].y, Vx, Vy)
                    S2MinProj = math.min(proj, S2MinProj)
                    S2MaxProj = math.max(proj, S2MaxProj)

            -- Se não houver overlapping eles não estão colidindo e já podemos retornar falso
            if S1MaxProj < S2MinProj or S2MaxProj < S1MinProj
                return 0, {0, 0}
            -- Calcula o overlapping
            auxOverlap1 = S1MaxProj - S2MinProj
            auxOverlap2 = S1MinProj - S2MaxProj
            if math.abs(auxOverlap1) < math.abs(auxOverlap2)
                overlap = auxOverlap1
            else
                overlap = auxOverlap2

            -- Inicializa vetor untiário que aponta pra sepração dos shapes se for o primeiro pontos
            if i == 1
                minOverlap = overlap
                mtv = {Vx, Vy}
            -- Se esse overlap for menor que o guardado em minOverlap, então atualiza minOverlap
            -- Também atualiza o vetor unitário que aponta pra sepração dos shapes
            elseif math.abs(overlap) < math.abs(minOverlap)
                minOverlap = overlap
                mtv = {Vx, Vy}

        return minOverlap, mtv

    rotatePolygon: (da, polygon) =>
        polygon.r += da
        for i = 1, #polygon.points
            nx, ny = vector.rotate(da, polygon.points[i].x - polygon.x, polygon.points[i].y - polygon.y)
            polygon.points[i].x = nx + polygon.x
            polygon.points[i].y = ny + polygon.y

        -- mantém polygon.r entre -2*pi e 2*pi (não sei se é realmente necessário)
        if polygon.r > 2*math.pi
            polygon.r = polygon.r % (2*math.pi)
        elseif polygon.r < -2*math.pi
            polygon.r = -polygon.r % (2*math.pi)

        -- Test collision
        for shape in *@shapes
            continue if shape == polygon
            coll, mtv = @isColliding(shape, polygon)
            if coll
                polygon\collided(shape, mtv, true)

    setPolygonAngle: (a, polygon) =>
        da = a - polygon.r
        polygon.r = a

        for i = 1, #polygon.points
            nx, ny = vector.rotate(da, polygon.points[i].x - polygon.x, polygon.points[i].y - polygon.y)
            polygon.points[i].x = nx + polygon.x
            polygon.points[i].y = ny + polygon.y

        -- mantém polygon.r entre -2*pi e 2*pi
        if polygon.r > 2*math.pi
            polygon.r = polygon.r % (2*math.pi)
        elseif polygon.r < 0
            polygon.r = 2*math.pi - polygon.r % (2*math.pi)

    movePolygon: (dx, dy, polygon) =>
        polygon.x += dx
        polygon.y += dy
        for i = 1, #polygon.points
            polygon.points[i].x += dx
            polygon.points[i].y += dy

        for shape in *@shapes
            continue if shape == polygon
            coll, mtv = @isColliding(shape, polygon)
            if coll
                polygon\collided(shape, mtv, false)

    movePolygonTo: (x, y, polygon) =>
        dx, dy = x - polygon.x, y - polygon.y

        polygon.x += dx
        polygon.y += dy
        for i = 1, #polygon.points
            polygon.points[i].x += dx
            polygon.points[i].y += dy

    update: (dt) =>
        for i = 1, #@shapes
            if @shapes[i].behavior ~= "static"
                @shapes[i]\move(@gravity.x * dt, @gravity.y * dt, @shapes[i])

    drawAllShapes: () =>
        for i = 1, #@shapes
            @shapes[i]\draw!

    -- a is the shape that moved and b is the shape that collided when a moved
    collisionStandartTreatment: (a, b, mtv, rotated) =>
        if rotated
            if a.behavior == "dynamic"
                if b.behavior == "static"
                    a\moveTo(a.x + mtv.x, a.y + mtv.y)
                elseif b.behavior == "dynamic"
                    a\moveTo(a.x + mtv.x/2, a.y + mtv.y/2)
                    b\moveTo(b.x - mtv.x/2, b.y - mtv.y/2)
            elseif a.behavior == "static"
                if b.behavior == "dynamic"
                    b\moveTo(b.x - mtv.x, b.y - mtv.y)

        else
            -- print "mtv.x: #{mtv.x} mtv.y: #{mtv.y}"
            if b.behavior == "static"
                a\moveTo(a.x + mtv.x, a.y + mtv.y)
            elseif b.behavior == "dynamic"
                a\moveTo(a.x + mtv.x/2, a.y + mtv.y/2)
                b\moveTo(b.x - mtv.x/2, b.y - mtv.y/2)

export AC = allcoll!

vector = require "../libs/vector-light"

-- Retorna verdadeiro ou falso caso os shapes
export isColl = (aabb1, aabb2) ->
    (aabb1.x + aabb1.w > aabb2.x and aabb2.x + aabb2.w > aabb1.x) and (aabb1.y + aabb1.h > aabb2.y and aabb2.y + aabb2.h > aabb1.y)

-- Retorna três valores o mínimo necessário em x e em y para separar os shapes e em que parte se deu a colisão
-- O argumento fix é um aabb que não se moverá e o move é um aabb que se moverá para separá-los
export mtv = (fix, move) ->
    top    = fix.y - (move.y + move.h)
    bottom = (fix.y + fix.h) - move.y
    left   = fix.x - (move.x + move.w)
    right  = (fix.x + fix.w) - move.x

    min = math.min(math.abs(top), math.abs(bottom), math.abs(left), math.abs(right))

    if     min == math.abs(top) then return 0, top, "top"
    elseif min == math.abs(bottom) then return 0, bottom, "bottom"
    elseif min == math.abs(left) then return left, 0, "left"
    elseif min == math.abs(right) then return right, 0, "right"

class_name HexHelper
extends Object

static var hex_directions := [	Hex.new(1, 0), Hex.new(1, -1), Hex.new(0, -1), Hex.new(-1, 0), Hex.new(-1, 1), Hex.new(0, 1) ]

static func HexEqual(a: Vector3, b: Vector3):
	return a == b

static func HexNotEqual(a: Vector3, b: Vector3):
	return a != b

static func hex_add(a: Hex, b: Hex) -> Hex:
	var vector = a.v + b.v
	return Hex.new(vector.x, vector.y)

static func hex_subtract(a: Hex, b: Hex) -> Hex:
	var vector = a.v - b.v
	return Hex.new(vector.x, vector.y)

static func hex_multiply(a: Hex, k: int) -> Hex:
	var vector = a.v * k
	return Hex.new(vector.x, vector.y)

static func hex_length(hex: Hex) -> int:
	return int((abs(hex.q()) + abs(hex.r()) + abs(hex.s())) / 2)

static func hex_distance(a: Hex, b: Hex) -> int:
	return hex_length(hex_subtract(a, b))

static func hex_direction(direction: int):
	if !(direction < 0) and !(direction > 5):
		return hex_directions[direction]
	
static func hex_neighbor(hex: Hex, direction: int) -> Hex:
	return hex_add(hex, hex_direction(direction))


static func hex_round(h: FractionalHex) -> Hex:
	var q: int = int(round(h.q()))
	var r: int = int(round(h.r()))
	var s: int = int(round(h.s()))
	var q_diff: float = abs(q - h.q())
	var r_diff: float = abs(r - h.r())
	var s_diff: float = abs(s - h.s())
	if ((q_diff > r_diff) and q_diff > s_diff):
		q = -r - s
	elif (r_diff > s_diff):
		r = -q - s
	else:
		s = -q - r
	return Hex.new(q, r)

static func lerp(a: float, b: float, t: float) -> float:
	return a * (1-t) + b * t

static func hex_lerp(a: Hex, b: Hex, t: float) -> FractionalHex:
	return FractionalHex.new(lerp(a.q(), b.q(), t),
						lerp(a.r(), b.r(), t))

static func hex_linedraw(a: Hex, b: Hex) -> Array:
	var N: int = hex_distance(a, b)
	var a_nudge = Hex.new(a.q() + 1e-06, a.r() + 1e-06)
	var b_nudge = Hex.new(b.q() + 1e-06, b.r() + 1e-06)
	var results: Array = []
	var step: float = 1.0 / max(N, 1)
	for i in range(N + 1):
		results.append(hex_round(hex_lerp(a_nudge, b_nudge, step * i)))
	return results

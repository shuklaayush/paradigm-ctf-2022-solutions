#!/usr/bin/env python3


class Pool:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def swap_x(self, dx):
        inv = self.x * self.y
        old_y = self.y
        self.x += dx
        self.y = inv // self.x
        dy = old_y - self.y
        return dy

    def swap_y(self, dy):
        inv = self.x * self.y
        old_x = self.x
        self.y += dy
        self.x = inv // self.y
        dx = old_x - self.x
        return dx

    def __repr__(self):
        return f"{self.x},{self.y}"


class Person:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __repr__(self):
        return f"{self.x},{self.y}"


class PoolPerson:
    def __init__(self, pool, person):
        self.pool = pool
        self.person = person
        self.swaps = []

    def swap_x(self, dx):
        assert self.person.x >= dx
        self.swaps.append(["x", dx])

        dy = pool.swap_x(dx)
        self.person.x -= dx
        self.person.y += dy

        return dy

    def swap_y(self, dy):
        assert self.person.y >= dy
        self.swaps.append(["y", dy])

        dx = pool.swap_y(dy)
        self.person.y -= dy
        self.person.x += dx

        return dx

    def __repr__(self):
        return f"Pool: {str(pool)} | Person: {str(person)}"


def perfect_x(pool, user):
    maxfx, maxdx = 0, 0
    inv = pool.x * pool.y
    for dx in range(1, user.x + 1):
        f = inv % (pool.x + dx)
        if f > maxfx:
            maxfx = f
            maxdx = dx
    return maxfx, maxdx


def perfect_y(pool, user):
    maxfy, maxdy = 0, 0
    inv = pool.x * pool.y
    for dy in range(1, user.y + 1):
        f = inv % (pool.y + dy)
        if f > maxfy:
            maxfy = f
            maxdy = dy
    return maxfy, maxdy


if __name__ == "__main__":
    pool = Pool(10, 10)
    person = Person(10, 0)

    game = PoolPerson(pool, person)
    print(game)

    while pool.x + pool.y > 1:
        fx, dx = perfect_x(pool, person)
        fy, dy = perfect_y(pool, person)

        if fx == 0 and fy == 0:
            if person.x > person.y:
                game.swap_x(1)
            else:
                game.swap_y(1)
        else:
            if fx > fy:
                game.swap_x(dx)
            else:
                game.swap_y(dy)
        print(game)

    print(len(game.swaps))
    print([s[0] for s in game.swaps])
    print([s[1] for s in game.swaps])

local Projectile = require(script.Projectile);

local ProjectileObj = Projectile.new();
ProjectileObj:Toggle();

local RND = Random.new();

while task.wait() do
	ProjectileObj:Fire(RND:NextUnitVector()*100, 1);
end
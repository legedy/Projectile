local RunService = game:GetService('RunService');

local Projectile = {};
Projectile.__index = Projectile;

function Projectile.new()
	local self = setmetatable({
		_TotalProjectiles = 0,
		_Connection = RunService.Heartbeat:Once(function() end),
		_Queue = {},

		LifeTime = 5,
		Direction = Vector3.yAxis,
		Speed = 10
	}, Projectile);

	self._Connection:Disconnect();

	return self;
end

function Projectile:Toggle(overrideBool: boolean?)

	if (overrideBool ~= nil) then
		if (overrideBool) then
			self._Connection = RunService.Heartbeat:Connect(function(deltaTime)
				self:_Step(deltaTime);
			end);
		else
			self._Connection:Disconnect();
		end
		return
	end

	if (self._Connection.Connected) then
		self._Connection:Disconnect();
	else
		self._Connection = RunService.Heartbeat:Connect(function(deltaTime)
			print(deltaTime);
			self:_Step(deltaTime);
		end);
	end
end

function Projectile:Fire(Velocity: Vector3?, LifeTime: number?)
	local Attachment = Instance.new('Attachment');
	Attachment.Visible = true;
	Attachment.Parent = workspace.Terrain;

	table.insert(self._Queue, {
		Time = 0,
		Attachment = Attachment,
		Velocity = Velocity or (self.Direction * self.Speed),
		LifeTime = LifeTime or self.LifeTime
	});
end

function Projectile:SetSpeed(Speed)
	self.Speed = Speed;
end

function Projectile:SetDirection(Direction)
	self.Direction = Direction;
end

function Projectile:_Step(deltaTime)
	for key, v in pairs(self._Queue) do
		coroutine.wrap(function()
			if (v.Time >= v.LifeTime) then
				v.Attachment:Destroy();
				table.remove(self._Queue, key);
				return
			end
	
			v.Velocity -= (v.Velocity / 100);
			v.Attachment.Position += v.Velocity * deltaTime;
			v.Time += deltaTime;
		end)();
	end
end

function Projectile:Destroy()
	table.clear(self);
	setmetatable(self, nil);
end

return Projectile;
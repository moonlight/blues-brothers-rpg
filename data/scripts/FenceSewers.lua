-- 
-- The Fences in the Sewers.
-- By Georg Muntingh

import("Decoration.lua")


FenceH3 = Decoration:subclass
{
	name = "FenceH3";

	init = function(self)
		self:updateBitmap()
		Decoration.init(self)
	end;

	switch = function(self)
		if (self.isOpen == false) then
			self.isOpen = true
			self.obstacle = 0
		else
			self.isOpen = false
			self.obstacle = 1
		end

		self:updateBitmap()
	end;

	updateBitmap = function(self)
		if (self.isOpen == false) then
			self.bitmap = self.bitmaps[1]
		else
			self.bitmap = self.bitmaps[2]
		end
	end;
	
	defaultproperties = {
		bCenterBitmap = false,
		bCenterOnTile = false,
		isOpen = false,
		obstacle = 1,
		h = 1,
		w = 3,
		draw_mode = DM_MASKED,
		bitmaps = extr_array(m_get_bitmap("fence_h3.bmp"), 73, 60),
		convTableKeyword = "CantPassFence",
	}
}

FenceH5 = Decoration:subclass
{
	name = "FenceH5";

	init = function(self)
		self:updateBitmap()
		Decoration.init(self)
	end;

	switch = function(self)
		if (self.isOpen == false) then
			self.isOpen = true
			self.obstacle = 0
		else
			self.isOpen = false
			self.obstacle = 1
		end

		self:updateBitmap()
	end;

	updateBitmap = function(self)
		if (self.isOpen == false) then
			self.bitmap = self.bitmaps[1]
		else
			self.bitmap = self.bitmaps[2]
		end
	end;
	
	defaultproperties = {
		bCenterBitmap = false,
		bCenterOnTile = false,
		isOpen = false,
		obstacle = 1,
		h = 1,
		w = 5,
		draw_mode = DM_MASKED,
		bitmaps = extr_array(m_get_bitmap("fence_h5.bmp"), 121, 60),
		bitmap = m_get_bitmap("Fence_h5.bmp"),
		convTableKeyword = "CantPassFence",
	}
}

FenceH7 = Decoration:subclass
{
	name = "FenceH7";

	init = function(self)
		self.bitmap = self.bitmaps[1]
		Decoration.init(self)
	end;

	switch = function(self)
		if (self.isOpen == false) then
			self.isOpen = true
			self.obstacle = 0
		else
			self.isOpen = false
			self.obstacle = 1
		end

		self:updateBitmap()
	end;

	updateBitmap = function(self)
		if (self.isOpen == false) then
			self.bitmap = self.bitmaps[1]
		else
			self.bitmap = self.bitmaps[2]
		end
	end;

	defaultproperties = {
		bCenterBitmap = false,
		bCenterOnTile = false,
		isOpen = false,
		obstacle = 1,
		h = 1,
		w = 7,
		draw_mode = DM_MASKED,
		bitmaps = extr_array(m_get_bitmap("fence_h7.bmp"), 169, 60),
		convTableKeyword = "CantPassFence",
	}
}

FenceV8 = Decoration:subclass
{
	name = "FenceV8";

	defaultproperties = {
		bCenterBitmap = false,
		bCenterOnTile = false,
		offset_y = -34,
		offset_x = 5,
		obstacle = 1,
		w = 1,
		h = 8,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("Fence_v8.bmp"),
		convTableKeyword = "CantPassFence",
	}
}

FenceV7 = Decoration:subclass
{
	name = "FenceV7";

	defaultproperties = {
		bCenterBitmap = false,
		bCenterOnTile = false,
		offset_y = -33,
		obstacle = 1,
		w = 1,
		h = 7,
		draw_mode = DM_MASKED,
		bitmap = m_get_bitmap("Fence_v7.bmp"),
		convTableKeyword = "CantPassFence",
	}
}

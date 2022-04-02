/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef FS_PODIUM_H_CF65BECF5129B787F25DF96395759CCA
#define FS_PODIUM_H_CF65BECF5129B787F25DF96395759CCA

#include "item.h"

#include <bitset>

class Player;

class Podium final : public Item
{
	public:
		explicit Podium(uint16_t type) : Item(type) {};

		Podium* getPodium() override {
			return this;
		}
		const Podium* getPodium() const override {
			return this;
		}

		Attr_ReadValue readAttr(AttrTypes_t attr, PropStream& propStream) override;
		void serializeAttr(PropWriteStream& propWriteStream) const override;

		void setOutfit(const Outfit_t& newOutfit) {
			outfit = newOutfit;
		}
		const Outfit_t getOutfit() const {
			return outfit;
		}

		bool hasFlag(PodiumFlags flag) const {
			return flags.test(flag);
		}
		void setFlagValue(PodiumFlags flag, bool value) {
			if (value) {
				flags.set(flag);
			} else {
				flags.reset(flag);
			}
		}
		void setFlags(uint8_t newFlags) {
			flags = newFlags;
		}

		const Direction getDirection() const {
			return direction;
		}
		void setDirection(Direction newDirection) {
			direction = newDirection;
		}

	protected:
		Outfit_t outfit;

	private:
		std::bitset<3> flags = { true }; // show platform only
		Direction direction = DIRECTION_SOUTH;
};

#endif

import { faker } from "@faker-js/faker";

export function generateBodyTemperatureData() {
  return {
    type: "body_temperature",
    data: {
      temperature: faker.datatype.number({ min: 33, max: 42 }),
    },
    user_id: faker.datatype.uuid(),
  };
}

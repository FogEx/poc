import { faker } from "@faker-js/faker";

export function generateVitalSigns() {
  return {
    type: "vital_signs",
    data: {
      hearth_rate: faker.datatype.number({ min: 30, max: 190 }),
      respiratory_rate: faker.datatype.number({ min: 10, max: 18 })
    },
    user_id: faker.datatype.uuid(),
  };
}


import { generateVitalSigns } from './generators/vital-signs'
import * as fs from 'fs';

const json = []
const dataLength = 10000;

console.info("Starting data generation")

for (let index = 0; index < dataLength; index++) {
  const data = generateVitalSigns();

  json.push(data)
}

fs.writeFileSync('./build/data.json', JSON.stringify(json));

console.info("Finished data generation")

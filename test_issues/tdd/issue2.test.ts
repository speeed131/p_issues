import { describe, expect, it } from 'vitest';
import { multiply, add, subtract, divide } from './issue2';



describe('Issue 2', () => {
    describe('multiply', () => {
        it('should return 90 when multiplying 3, 10, and 3', () => {
            expect(multiply(3, 10, 3)).to.equal(90);
        });
    });
    describe('add', () => {
        it('should return 16 when adding 3, 10, and 3', () => {
            expect(add(3, 10, 3)).to.equal(16);
        });
    });
    describe('subtract', () => {
        it('should return -10 when subtracting 3, 10, and 3', () => {
            expect(subtract(3, 10, 3)).to.equal(-10);
        });
    });
    describe('divide', () => {
        it('should return 10 when dividing 100 by 10', () => {
            expect(divide(100, 10)).to.equal(10);
        });
    });

})
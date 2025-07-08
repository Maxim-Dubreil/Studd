declare module '@hotwired/turbo-rails' {
  export const Turbo: {
    start(): void;
    visit(url: string): void;
    [key: string]: any;
  };
}

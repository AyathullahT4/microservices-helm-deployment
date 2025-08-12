FROM node:20-alpine
WORKDIR /app
COPY app.js .
RUN npm init -y && npm i express
ENV PORT=3000
EXPOSE 3000
CMD ["node", "app.js"]

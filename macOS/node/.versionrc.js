module.exports = {
  bumpFiles: [
    {
      filename: "VERSION",
      updater: {
        readVersion: (contents) => contents,
        writeVersion: (_, version) => version,
      },
    },
  ],
};

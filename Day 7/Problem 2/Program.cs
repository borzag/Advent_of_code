// See https://aka.ms/new-console-template for more information

var root = new RDirectory{Name = "/"};
var currentDirectory = root;

const int TotalFileSystemSize = 70000000;
const int UpdateSize = 30000000;

foreach (var line in File.ReadLines(@"Data\inputdata.txt"))
{
    var command = line.Split(" ");
    
    switch (command[0])
    {
        case @"$":
            switch (command[1])
            {
                case @"ls":
                    break;

                case @"cd":
                    Navigate(command[2]);

                    void Navigate(string cmd)
                    {
                        if (cmd != "/")
                        {
                            currentDirectory = cmd == ".."
                                ? currentDirectory.Parent
                                : currentDirectory.Directories.FirstOrDefault(x => x.Name == cmd);
                        }
                    }

                    break;
            }
            break;

        case @"dir":
            currentDirectory.Directories.Add(new RDirectory
            {
                Name = command[1],
                Parent = currentDirectory,
            });
            break;

        default:
            ReadFile(command);

            void ReadFile(IReadOnlyList<string> commands)
            {
                currentDirectory.Files.Add(new RFile
                {
                    Size = int.Parse(commands[0]),
                    Name = commands[1],
                });
            }
            break;
    }
}

PrintFileTree();
var freeSpace = TotalFileSystemSize - root.Size;
var sizeLimit = UpdateSize - freeSpace;

var smallestDir = root;
foreach (var directory in root.GetAllDirectories(root))
{
    var directorySize = directory.Size;
    if (directorySize >= sizeLimit && directorySize < smallestDir.Size )
        smallestDir = directory;
}

Console.WriteLine($"\nSpace to remove is {sizeLimit}. The directory to remove with smallest size ,\n" +
                  $"to get enough space for the update is: {smallestDir.Size}");

void PrintFileTree()
{
    root.Print(0);
}

public abstract record FileSystemItem
{
    public string Name { get; init; } = default!;
    public int Size { get; init; }
    public abstract void Print(int margin);
}

public record RDirectory : FileSystemItem
{
    public RDirectory? Parent { get; init; }
    public List<RFile> Files = new();
    public List<RDirectory> Directories = new();

    public new int Size
    {
        get
        {
            var sum = 0;
            foreach (var directory in Directories)
            {
                sum += directory.Size;
            }

            return FilesSize() + sum;
        }
    }

    public int ConditionalSize(int sizeLimit)
    {
        var sum = 0;
        foreach (var directory in Directories)
        {
            var size = directory.ConditionalSize(sizeLimit);
            if (size <= sizeLimit)
                sum += size;
        }

        var fileSize = FilesSize();
        if (fileSize <= sizeLimit)
        {
            sum += fileSize;
        }

        return sum;
    }

    private int FilesSize()
    {
        return Files.Sum(file => file.Size);
    }

    public override void Print(int margin)
    {
        PrintCurrentDirectory(margin);
        var spaces = margin + 2;
        foreach (var directory in Directories)
        {
            directory.Print(spaces);
        }

        foreach (var file in Files)
        {
            file.Print(spaces);
        }
    }

    private void PrintCurrentDirectory(int spaces)
    {
        Console.WriteLine($"{new string(' ', spaces)}-{Name} (Dir, {Size})");
    }

    public IEnumerable<RDirectory> GetAllDirectories(RDirectory currentDirectory)
    {
        var dirs = new List<RDirectory>(Directories);
        foreach (var directory in currentDirectory.Directories)
        {
            dirs.AddRange(directory.GetAllDirectories(directory));
        }

        return dirs;
    }
}

public record RFile : FileSystemItem
{
    public override void Print(int spaces)
    {
        Console.WriteLine($"{new string(' ', spaces)}-{Name} (File, {Size})");
    }
}